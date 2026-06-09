const { Client } = require('pg');
const client = new Client({ connectionString: 'postgresql://dev_user:securepassword@localhost:5432/majadigi' });
client.connect().then(() => {
  return client.query(`
    INSERT INTO bansos.bansos_programs (id, nama_program, deskripsi, persyaratan_json, periode) 
    VALUES ('pkh-2026', 'Program Keluarga Harapan', 'Bantuan sosial bersyarat', '{"max_penghasilan_bulanan":2500000}', '2026') 
    ON CONFLICT DO NOTHING;
  `);
}).then(() => {
  return client.query(`
    INSERT INTO bansos.bansos_programs (id, nama_program, deskripsi, persyaratan_json, periode) 
    VALUES ('bpnt-2026', 'Bantuan Pangan Non Tunai', 'Bantuan pangan bulanan', '{"max_penghasilan_bulanan":2000000}', '2026') 
    ON CONFLICT DO NOTHING;
  `);
}).then(() => {
  console.log('Seeded bansos_programs');
  process.exit(0);
}).catch(e => {
  console.error(e);
  process.exit(1);
});
