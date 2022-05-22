CREATE TABLE
  "accounts" (
    "id" bigserial PRIMARY KEY,
    "owner" VARCHAR NOT NULL,
    "balance" BIGINT NOT NULL,
    "currency" VARCHAR NOT NULL,
    "created_at" timestamptz NOT NULL DEFAULT (NOW())
  );


CREATE TABLE
  "entries" (
    "id" bigserial PRIMARY KEY,
    "account_id" BIGINT NOT NULL,
    "amount" BIGINT NOT NULL,
    "created_at" timestamptz NOT NULL DEFAULT (NOW())
  );


CREATE TABLE
  "transfers" (
    "id" bigserial PRIMARY KEY,
    "from_account_id" BIGINT NOT NULL,
    "to_account_id" BIGINT NOT NULL,
    "amount" BIGINT NOT NULL,
    "created_at" timestamptz NOT NULL DEFAULT (NOW())
  );


CREATE INDEX ON "accounts" ("owner");


CREATE INDEX ON "entries" ("account_id");


CREATE INDEX ON "transfers" ("from_account_id");


CREATE INDEX ON "transfers" ("to_account_id");


CREATE INDEX
  ON "transfers" ("from_account_id", "to_account_id");


COMMENT
  ON COLUMN "entries"."amount" IS 'can be positive or negative';


COMMENT
  ON COLUMN "transfers"."amount" IS 'must be positive';


ALTER TABLE "entries"
ADD
  FOREIGN KEY ("account_id") REFERENCES "accounts" ("id");


ALTER TABLE "transfers"
ADD
  FOREIGN KEY ("from_account_id") REFERENCES "accounts" ("id");


ALTER TABLE "transfers"
ADD
  FOREIGN KEY ("to_account_id") REFERENCES "accounts" ("id");
