drop table if exists user;
create table user (
  user_id integer primary key autoincrement,
  username text unique,
  uuid text unique not null,
  api_token text unique not null
);

--drop table if exists follower;
--create table follower (
--  who_id integer,
--  whom_id integer
--);

--drop table if exists message;
--create table message (
--  message_id integer primary key autoincrement,
--  author_id integer not null,
--  text text not null,
--  pub_date integer
--);