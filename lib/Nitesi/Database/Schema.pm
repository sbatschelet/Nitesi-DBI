=head1 NAME 

Nitesi::Database::Schema - Database schema for Nitesi

=head1 DESCRIPTION

This document describes the proposed database schema for L<Nitesi>,
the Open Source Shop Machine.

The C<CREATE TABLE> statements are written for MySQL, but should
work with small adjustments for PostgreSQL too.

=head2 PRODUCTS

Products are stored in the C<products> table.

=head3 products table

    CREATE TABLE products (
      sku varchar(32) NOT NULL PRIMARY KEY,
      name varchar(255) NOT NULL DEFAULT '',
      description text NOT NULL DEFAULT '',
      price decimal(10,2) NOT NULL DEFAULT 0,
      priority integer NOT NULL DEFAULT 0,
      inactive boolean NOT NULL DEFAULT FALSE
    );

=over 4

=item sku

Unique product identifier

=item name

Product name.

=item description

Product description.

=item price

Product price.

=item priority

The product priority is used for sorting products on
search results and category listings.

=item inactive

Inactive products are excluded from search results and
category listings.

=back

=head2 NAVIGATION

Menus and (product) categories are stored in the C<navigation> table.

=head3 navigation table

    CREATE TABLE navigation (
      code serial NOT NULL PRIMARY KEY,
      uri varchar(255) NOT NULL DEFAULT '',
      type varchar(32) NOT NULL DEFAULT '',
      scope varchar(32) NOT NULL DEFAULT '',
      name varchar(255) NOT NULL DEFAULT '',
      description text NOT NULL DEFAULT '',
      parent integer NOT NULL DEFAULT 0,
      priority integer NOT NULL DEFAULT 0,
      inactive boolean NOT NULL default FALSE,
      entered timestamp DEFAULT CURRENT_TIMESTAMP
    );

=over 4

=item uri

Full or relative URL.

=item type

Navigation type, e.g. menu or category.

=item scope

Scope related to type, menu name for menus
or categorization (brand, star) for categories.

=back

=head3 navigation_products table

    CREATE TABLE navigation_products (
      sku varchar(32) NOT NULL,
      navigation integer NOT NULL,
      type varchar(16) NOT NULL DEFAULT ''
    );

=head2 CARTS

Carts are stored in the C<carts> and C<carts_products> table.

=head3 C<carts> table

    CREATE TABLE carts (
      code integer NOT NULL,
      name character varying(255) DEFAULT ''::character varying NOT NULL,
      uid integer DEFAULT 0 NOT NULL,
      created integer DEFAULT 0 NOT NULL,
      last_modified integer DEFAULT 0 NOT NULL,
      type character varying(32) DEFAULT ''::character varying NOT NULL,
      approved boolean,
      status character varying(32) DEFAULT ''::character varying NOT NULL
   );

=head3 cart_products

    CREATE TABLE cart_products (
      cart integer NOT NULL,
      sku character varying(32) NOT NULL,
      "position" integer NOT NULL,
      quantity integer DEFAULT 1 NOT NULL,
      priority integer DEFAULT 0 NOT NULL
    );

=head2 USERS, ROLES, PERMISSIONS

=head3 users

    CREATE TABLE users (
      uid serial primary key,
      username varchar(32) NOT NULL,
      email varchar(255) NOT NULL DEFAULT '',
      password varchar(255) NOT NULL DEFAULT '',
      last_login integer NOT NULL DEFAULT 0,
      created integer NOT NULL DEFAULT 0
    );

=over 4

=item uid

Numeric primary key for users.

=item username

User name (usually lowercase of email).

=item email

Email address.

=item password

Encrypted password.

=item last_login

Time of last login

=item created

Time of account creation.

=back

=head3 roles

    CREATE TABLE roles (
      rid serial primary key,
      name varchar(32) NOT NULL,
      label varchar(255) NOT NULL
    );

    INSERT INTO roles (rid,name,label) VALUES (1, 'anonymous', 'Anonymous Users');
    INSERT INTO roles (rid,name,label) VALUES (2, 'authenticated', 'Authenticated Users');

=over 4

=item rid

Numeric primary key for roles.

=item name

Role name.

=item label

Role label (for display only).

=back

=head3 user_roles

    CREATE TABLE user_roles (
      uid integer DEFAULT 0 NOT NULL,
      rid integer DEFAULT 0 NOT NULL,
      CONSTRAINT user_roles_pkey PRIMARY KEY (uid, rid)
    );

    CREATE INDEX idx_user_roles_rid ON user_roles (rid);

=over 4

=item uid

Foreign key for user.

=item rid

Foreign key for role.

=back

=head3 permissions

    CREATE TABLE permissions (
      rid integer not null default 0,
      uid integer not null default 0,
      perm varchar(255) not null default ''
    );

    INSERT INTO permissions (rid,perm) VALUES (1,'anonymous');
    INSERT INTO permissions (rid,perm) VALUES (2,'authenticated');

Permissions are you usually granted to rules, but in somes
cases you may want to grant a permission to a specific user.

Please set either C<rid> or C<uid> and use 0 as value for the
other in a single record.

=over 4

=item rid

Foreign key for role.

=item uid

Foreign key for user.

=item perm

Permission, e.g. C<view_cart>, C<add_user>.

=back

=cut

=head2 TRANSACTIONS

=head3 transactions

    create table transactions (
      code serial not null,
      order_number varchar(24) NOT NULL DEFAULT '',
      order_date timestamp,
      uid integer NOT NULL DEFAULT 0,
      email varchar(255) NOT NULL DEFAULT '',
      aid_shipping integer NOT NULL DEFAULT 0,
      aid_billing integer NOT NULL DEFAULT 0,
      payment_method varchar(255) NOT NULL DEFAULT '',
      payment_code varchar(255) NOT NULL DEFAULT '',
      shipping_method varchar(255) NOT NULL DEFAULT '',
      shipping_code varchar(255) NOT NULL DEFAULT '',
      subtotal numeric(11,2) NOT NULL DEFAULT 0,
      shipping numeric(11,2) NOT NULL DEFAULT 0,
      handling numeric(11,2) NOT NULL DEFAULT 0,
      salestax numeric(11,2) NOT NULL DEFAULT 0,
      total_cost numeric(11,2) NOT NULL DEFAULT 0,
      status varchar(24) NOT NULL DEFAULT '',
      CONSTRAINT transactions_pkey PRIMARY KEY (code)
    );

=head2 SETTINGS

Settings stored in the database, used to complement the
settings retrieved from the web framework configuration,
e.g. L<Dancer::Config>.

=head3 settings

    CREATE TABLE settings (
      code serial primary key,
      scope varchar(32) NOT NULL,
      site varchar(32) NOT NULL default '',
      name varchar(32) NOT NULL,
      value text NOT NULL,
      category varchar(32) NOT NULL default ''
    );

    CREATE INDEX settings_scope ON settings (scope);

=head3 

=head2 OTHER

=head3 path_redirect

=cut
