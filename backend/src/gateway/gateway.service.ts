import { Injectable } from '@nestjs/common';
import { DatabaseService } from '../common/database/database.service';

@Injectable()
export class GatewayService {
  constructor(private readonly database: DatabaseService) {}

  private readonly fallbackFeatures = [
    { key: 'bapenda', name: 'Bapenda Jatim', active: true, route: '/bapenda', requires_auth: true, icon_url: 'https://cdn.majadigi.go.id/icons/bapenda.png', version: '1.0.0' },
    { key: 'info_pkb', name: 'Info Pajak Kendaraan Bermotor', active: true, route: '/bapenda/pkb/check', requires_auth: true, icon_url: 'https://cdn.majadigi.go.id/icons/pkb.png', version: '1.0.0' },
    { key: 'info_njkb', name: 'Info NJKB', active: true, route: '/bapenda/njkb', requires_auth: false, icon_url: 'https://cdn.majadigi.go.id/icons/njkb.png', version: '1.0.0' },
    { key: 'klinik_hoaks', name: 'Klinik Hoaks', active: true, route: '/hoaks', requires_auth: false, icon_url: 'https://cdn.majadigi.go.id/icons/hoaks.png', version: '1.0.0' },
    { key: 'nomor_darurat', name: 'Nomor Darurat', active: true, route: '/emergency', requires_auth: false, icon_url: 'https://cdn.majadigi.go.id/icons/emergency.png', version: '1.0.0' },
    { key: 'point_jatim', name: 'Point Jatim', active: true, route: '/point-jatim', requires_auth: true, icon_url: 'https://cdn.majadigi.go.id/icons/point-jatim.png', version: '1.0.0' },
    { key: 'skrining_tbc', name: 'Skrining E-Tibi', active: true, route: '/tbc-screening', requires_auth: true, icon_url: 'https://cdn.majadigi.go.id/icons/tbc.png', version: '1.0.0' },
    { key: 'rsud_daha_husada', name: 'RSUD Daha Husada', active: true, route: '/rsud/daha', requires_auth: false, icon_url: 'https://cdn.majadigi.go.id/icons/rsud.png', version: '1.0.0' },
    { key: 'rsud_daha_surgeries', name: 'Jadwal Operasi RSUD Daha Husada', active: true, route: '/rsud/daha/surgeries', requires_auth: false, icon_url: 'https://cdn.majadigi.go.id/icons/surgery.png', version: '1.0.0' },
    { key: 'rsud_daha_queue', name: 'Info Antrian Pasien RSUD Daha Husada', active: true, route: '/rsud/daha/queue', requires_auth: true, icon_url: 'https://cdn.majadigi.go.id/icons/queue.png', version: '1.0.0' },
    { key: 'rsud_haji', name: 'RSUD Haji Provinsi Jawa Timur', active: true, route: '/rsud/haji', requires_auth: false, icon_url: 'https://cdn.majadigi.go.id/icons/rsud-haji.png', version: '1.0.0' },
    { key: 'rsud_haji_rooms', name: 'Info Kamar RSUD Haji', active: true, route: '/rsud/haji/rooms', requires_auth: false, icon_url: 'https://cdn.majadigi.go.id/icons/bed.png', version: '1.0.0' },
    { key: 'rsud_karsa_husada', name: 'RSUD Karsa Husada', active: true, route: '/rsud/karsa', requires_auth: false, icon_url: 'https://cdn.majadigi.go.id/icons/rsud-karsa.png', version: '1.0.0' },
    { key: 'rsud_karsa_rooms', name: 'Ketersediaan Kamar RSUD Karsa Husada', active: true, route: '/rsud/karsa/rooms', requires_auth: false, icon_url: 'https://cdn.majadigi.go.id/icons/bed.png', version: '1.0.0' },
    { key: 'sapa_bansos', name: 'SAPA Bansos', active: false, route: '/bansos', requires_auth: true, icon_url: 'https://cdn.majadigi.go.id/icons/bansos.png', version: '0.9.0' },
    { key: 'islamic_center', name: 'Islamic Center', active: true, route: '/islamic-center', requires_auth: true, icon_url: 'https://cdn.majadigi.go.id/icons/islamic-center.png', version: '1.0.0' },
  ];

  async getActiveFeatures() {
    const rows = await this.database.query<{
      feature_key: string;
      version: string;
      status: string;
      flutter_route: string;
      required_role: string;
    }>(
      `
        SELECT feature_key, version, status, flutter_route, required_role
        FROM gateway.active_features
        ORDER BY feature_key
      `,
    );

    if (rows) {
      return {
        active_features: rows.map((row) => ({
          key: row.feature_key,
          name: this.nameFromFeatureKey(row.feature_key),
          active: row.status === 'Active',
          route: row.flutter_route,
          requires_auth: row.required_role === 'RegisteredUser',
          icon_url: `https://cdn.majadigi.go.id/icons/${row.feature_key}.png`,
          version: row.version,
        })),
      };
    }

    return { active_features: this.fallbackFeatures };
  }

  private nameFromFeatureKey(featureKey: string) {
    const feature = this.fallbackFeatures.find((item) => item.key === featureKey);
    if (feature) {
      return feature.name;
    }

    return featureKey
      .split('_')
      .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
      .join(' ');
  }
}
