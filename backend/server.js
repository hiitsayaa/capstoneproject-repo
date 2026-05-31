const express = require('express');
const cors = require('cors');
const admin = require('firebase-admin');
const { createClient } = require('@supabase/supabase-js');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

// Inisialisasi Firebase Admin
const serviceAccount = require('./firebase-service-account.json');
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

// Inisialisasi Supabase Client
const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_ANON_KEY;
const supabase = createClient(supabaseUrl, supabaseKey);

// Endpoint Register
app.post('/api/users/register', async (req, res) => {
  try {
    // 1. Ambil token dari header Authorization
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ error: 'Unauthorized: Token missing' });
    }
    const idToken = authHeader.split('Bearer ')[1];

    // 2. Verifikasi Token menggunakan Firebase Admin
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const uid = decodedToken.uid;

    // 3. Ambil data dari body request
    const { 
      email, 
      nama_depan, 
      nama_belakang, 
      nomor_hp, 
      alamat, 
      nik, 
      tanggal_lahir, 
      jenis_kelamin 
    } = req.body;

    // 4. Simpan ke Supabase (user_profiles)
    const { data, error } = await supabase
      .from('user_profiles')
      .insert([
        {
          id: uid,
          email: email,
          nama_depan: nama_depan,
          nama_belakang: nama_belakang,
          nomor_hp: nomor_hp,
          alamat: alamat,
          nik: nik,
          tanggal_lahir: tanggal_lahir ? new Date(tanggal_lahir).toISOString() : null, // Handle format tanggal
          jenis_kelamin: jenis_kelamin
        }
      ]);

    if (error) {
      console.error('Supabase Error:', error);
      return res.status(400).json({ error: error.message });
    }

    res.status(201).json({ message: 'User profile created successfully', data });

  } catch (error) {
    console.error('Server Error:', error);
    res.status(500).json({ error: 'Internal server error', details: error.message });
  }
});

// Endpoint Google Login (Progressive Profiling)
app.post('/api/users/google-login', async (req, res) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ error: 'Unauthorized: Token missing' });
    }
    const idToken = authHeader.split('Bearer ')[1];

    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const uid = decodedToken.uid;
    const email = decodedToken.email;
    const name = decodedToken.name || '';

    // Cek apakah user sudah ada
    const { data: existingUser, error: checkError } = await supabase
      .from('user_profiles')
      .select('*')
      .eq('id', uid)
      .maybeSingle(); // gunakan maybeSingle agar tidak throw error jika tidak ada

    if (existingUser) {
      return res.status(200).json({ message: 'Login successful', data: existingUser });
    }

    // Jika belum ada, buat profil minimal
    let nama_depan = name;
    let nama_belakang = '';
    if (name.includes(' ')) {
      const parts = name.split(' ');
      nama_depan = parts[0];
      nama_belakang = parts.slice(1).join(' ');
    }

    const { data: newUser, error: insertError } = await supabase
      .from('user_profiles')
      .insert([{
        id: uid,
        email: email,
        nama_depan: nama_depan,
        nama_belakang: nama_belakang
      }])
      .select()
      .maybeSingle();

    if (insertError) {
      console.error('Supabase Error:', insertError);
      return res.status(400).json({ error: insertError.message });
    }

    res.status(201).json({ message: 'User created via Google', data: newUser });

  } catch (error) {
    console.error('Server Error:', error);
    res.status(500).json({ error: 'Internal server error', details: error.message });
  }
});

// Endpoint untuk update profil (saat user melengkapi data nanti)
app.put('/api/users/profile', async (req, res) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ error: 'Unauthorized: Token missing' });
    }
    const idToken = authHeader.split('Bearer ')[1];
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const uid = decodedToken.uid;

    const { nama_depan, nama_belakang, nomor_hp, alamat, nik, tanggal_lahir, jenis_kelamin } = req.body;

    const { data, error } = await supabase
      .from('user_profiles')
      .update({
        nama_depan,
        nama_belakang,
        nomor_hp,
        alamat,
        nik,
        tanggal_lahir: tanggal_lahir ? new Date(tanggal_lahir).toISOString() : null,
        jenis_kelamin
      })
      .eq('id', uid)
      .select()
      .maybeSingle();

    if (error) {
      console.error('Supabase Error:', error);
      return res.status(400).json({ error: error.message });
    }

    res.status(200).json({ message: 'Profile updated successfully', data });

  } catch (error) {
    console.error('Server Error:', error);
    res.status(500).json({ error: 'Internal server error', details: error.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
