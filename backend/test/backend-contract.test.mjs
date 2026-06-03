import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { join } from 'node:path';
import test from 'node:test';

const root = new URL('..', import.meta.url).pathname;

async function read(relativePath) {
  return readFile(join(root, relativePath), 'utf8');
}

test('backend exposes the Majadigi modular monolith route surface', async () => {
  const routeFiles = [
    ['src/gateway/gateway.controller.ts', ['@Get(\'features\')']],
    ['src/modules/auth/auth.controller.ts', ['@Post(\'auth/register\')', '@Post(\'auth/login\')', '@Get(\'profile/me\')', '@Patch(\'profile/favorites\')']],
    ['src/modules/bapenda/bapenda.controller.ts', ['@Get(\'pkb/check\')', '@Post(\'pkb/pay\')', '@Get(\'njkb\')']],
    ['src/modules/rsud/rsud.controller.ts', ['@Get(\'hospitals\')', '@Get(\':hospitalId/rooms\')', '@Post(\':hospitalId/queue\')', '@Get(\':hospitalId/surgeries\')']],
    ['src/modules/bansos/bansos.controller.ts', ['@Get(\'programs\')', '@Post(\'apply\')', '@Get(\'status\')']],
    ['src/modules/hoaks/hoaks.controller.ts', ['@Get(\'articles\')', '@Post(\'report\')']],
    ['src/modules/emergency/emergency.controller.ts', ['@Get(\'regions\')', '@Get(\'contacts\')', '@Get(\'contacts/:id\')']],
    ['src/modules/islamic-center/islamic-center.controller.ts', ['@Get(\'facilities\')', '@Get(\'facilities/:id\')', '@Post(\'bookings\')']],
    ['src/modules/point-jatim/point-jatim.controller.ts', ['@Get(\'projects\')', '@Get(\'projects/:id\')', '@Post(\'submissions\')']],
    ['src/modules/tbc-screening/tbc-screening.controller.ts', ['@Get(\'questions\')', '@Get(\'faskes\')', '@Post(\'records\')']],
    ['src/modules/tickets/tickets.controller.ts', ['@Get()', '@Get(\':id\')']]
  ];

  for (const [file, markers] of routeFiles) {
    const content = await read(file);
    for (const marker of markers) {
      assert.match(content, new RegExp(marker.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')), `${file} should include ${marker}`);
    }
  }
});

test('schema isolation creates each planned PostgreSQL schema and key tables', async () => {
  const sql = await read('init-schemas.sql');
  for (const schema of ['auth', 'bapenda', 'rsud', 'bansos', 'hoaks', 'gateway', 'emergency', 'islamic_center', 'point_jatim', 'tbc_screening']) {
    assert.match(sql, new RegExp(`CREATE SCHEMA IF NOT EXISTS ${schema};`));
  }

  for (const table of ['auth.users', 'auth.profiles', 'bapenda.vehicles', 'bapenda.pkb_bills', 'rsud.hospitals', 'bansos.applications', 'hoaks.hoax_articles', 'gateway.active_features', 'emergency.contacts', 'islamic_center.facilities', 'point_jatim.projects', 'tbc_screening.questions']) {
    assert.match(sql, new RegExp(`CREATE TABLE IF NOT EXISTS ${table.replace('.', '\\.')}`));
  }
});

test('deployment and load testing assets are present', async () => {
  const dockerfile = await read('Dockerfile');
  assert.match(dockerfile, /FROM node:20-alpine AS builder/);
  assert.match(dockerfile, /FROM node:20-alpine AS runner/);

  const compose = await read('docker-compose.yml');
  assert.match(compose, /majadigi-postgres:/);
  assert.match(compose, /majadigi-backend:/);
  assert.match(compose, /01-init-schemas\.sql/);
  assert.match(compose, /02-seed-demo\.sql/);

  const k6 = await read('k6/pkb-check.js');
  assert.match(k6, /\/bapenda\/pkb\/check\?nopol=N1234AB/);
});

test('demo seed data covers all presentation modules', async () => {
  const seed = await read('seed-demo.sql');
  for (const table of [
    'auth.users',
    'auth.profiles',
    'auth.favorites',
    'bapenda.vehicles',
    'bapenda.pkb_bills',
    'bapenda.pkb_payments',
    'bapenda.njkb_data',
    'rsud.hospitals',
    'rsud.room_availability',
    'rsud.queues',
    'rsud.surgeries',
    'bansos.bansos_programs',
    'bansos.applications',
    'bansos.documents',
    'hoaks.hoax_articles',
    'hoaks.hoax_reports',
    'gateway.active_features',
    'emergency.contacts',
    'islamic_center.facilities',
    'islamic_center.bookings',
    'point_jatim.projects',
    'point_jatim.submissions',
    'tbc_screening.questions',
    'tbc_screening.faskes',
    'tbc_screening.records'
  ]) {
    assert.match(seed, new RegExp(`INSERT INTO ${table.replace('.', '\\.')}`), `seed-demo.sql should seed ${table}`);
  }

  assert.match(seed, /ON CONFLICT/);
  assert.match(seed, /demo@majadigi\.go\.id/);
  assert.match(seed, /N1234AB/);
  assert.match(seed, /RSUD Daha Husada/);
  assert.match(seed, /Command Center 112 Surabaya/);
  assert.match(seed, /Aula Utama Islamic Center/);
  assert.match(seed, /Peternakan Sapi Perah Terintegrasi Modern/);
  assert.match(seed, /rsud_haji/);
  assert.match(seed, /info_njkb/);
  assert.match(seed, /Batuk \(lebih dari 2 minggu atau kurang dari 2 minggu\)/);
  assert.match(seed, /Lansia \(diatas 60 tahun\)/);
});
