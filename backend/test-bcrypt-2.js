const bcrypt = require('bcryptjs');
const hash = '$2b$10$8C9PjI9rdd6hW35w9xgWPeIjqZ1VntmUVY4zF2yt4i0DSsQf7QvxW';
console.log('Does original seed hash match password?', bcrypt.compareSync('password', hash));
