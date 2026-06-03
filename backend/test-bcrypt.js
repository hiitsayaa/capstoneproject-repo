const bcrypt = require('bcrypt');

const hash = '$2b$10$8C9PjI9rdd6hW35w9xgWPeIjqZ1VntmUVY4zF2yt4i0DSsQf7QvxW';
const password = 'password';

bcrypt.compare(password, hash, function(err, result) {
    console.log("Match:", result);
});
