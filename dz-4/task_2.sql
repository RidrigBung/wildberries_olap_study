CREATE USER babanin identified WITH sha256_password BY '2425';
grant current grants on *.* to babanin with grant option;
