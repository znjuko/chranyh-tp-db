DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS forums CASCADE;
DROP TABLE IF EXISTS threadUF CASCADE;
DROP TABLE IF EXISTS threads;
DROP TABLE IF EXISTS messageTU CASCADE;
DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS counter;
DROP TABLE IF EXISTS voteThreads;
DROP TABLE IF EXISTS forumUsers;
DROP FUNCTION IF EXISTS user_counter();
DROP FUNCTION IF EXISTS forum_counter();
DROP FUNCTION IF EXISTS thread_counter();
DROP FUNCTION IF EXISTS message_counter();
CREATE EXTENSION IF NOT EXISTS CITEXT;

CREATE TABLE users
(
    u_id     BIGSERIAL PRIMARY KEY,
    nickname CITEXT COLLATE "C" NOT NULL UNIQUE,
    fullname VARCHAR(100)       NOT NULL,
    email    CITEXT             NOT NULL UNIQUE,
    about    TEXT
);

CREATE INDEX idx_users_nickname ON users(nickname,email);

CREATE TABLE forums
(
    f_id         BIGSERIAL PRIMARY KEY,
    slug         CITEXT UNIQUE NOT NULL,
    title        TEXT,
    post_counter BIGINT DEFAULT 0,
    u_nickname   CITEXT COLLATE "C" REFERENCES users (nickname) ON DELETE CASCADE

);

CREATE TABLE threads
(
    t_id       BIGSERIAL PRIMARY KEY,
    slug       CITEXT UNIQUE,
    date       TIMESTAMP WITH TIME ZONE,
    message    TEXT,
    title      TEXT,
    votes      BIGINT DEFAULT 0,
    u_nickname CITEXT COLLATE "C" REFERENCES users (nickname) ON DELETE CASCADE,
    f_slug     CITEXT NOT NULL REFERENCES forums (slug) ON DELETE CASCADE
);

CREATE TABLE voteThreads
(
    t_id       BIGINT NOT NULL REFERENCES threads ON DELETE CASCADE,
    counter    INT DEFAULT 0,
    u_nickname CITEXT COLLATE "C" REFERENCES users (nickname) ON DELETE CASCADE
);

CREATE TABLE messages
(
    m_id       BIGSERIAL PRIMARY KEY,
    date       TIMESTAMP WITH TIME ZONE,
    message    TEXT,
    edit       BOOLEAN DEFAULT false,
    parent     BIGINT,
    path       BIGINT[],
    u_nickname CITEXT COLLATE "C" REFERENCES users (nickname) ON DELETE CASCADE,
    f_slug     CITEXT NOT NULL REFERENCES forums (slug) ON DELETE CASCADE,
    t_id       BIGINT NOT NULL REFERENCES threads ON DELETE CASCADE
);

CREATE TABLE forumUsers
(
    f_slug BIGINT NOT NULL REFERENCES forums(slug) ON DELETE CASCADE,
    u_nickname BIGINT NOT NULL REFERENCES users(nickname) ON DELETE CASCADE
);

CREATE INDEX idx_forumusers_slugid ON forumUsers(f_slug,u_nickname);

