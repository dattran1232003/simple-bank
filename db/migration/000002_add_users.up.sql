CREATE TABLE IF NOT EXISTS "users" (
  "username" VARCHAR PRIMARY KEY,
  "hashed_password" VARCHAR NOT NULL,
  "full_name" VARCHAR NOT NULL,
  "email" VARCHAR UNIQUE NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (NOW()),
  "password_changed_at" timestamptz NOT NULL DEFAULT '0001-01-01'
);


-- foreign keys
ALTER TABLE IF EXISTS "accounts"
  ADD FOREIGN KEY ("owner")
  REFERENCES "users" ("username");


-- indexes
-- CREATE UNIQUE INDEX ON "accounts" ("owner", "currency");
ALTER TABLE "accounts" ADD CONSTRAINT "own_currency_key" UNIQUE ("owner", "currency");
