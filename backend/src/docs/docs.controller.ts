import { Controller, Get, Header } from '@nestjs/common';
import { Public } from '../common/decorators/public.decorator';
import { openApiDocument } from './openapi.document';

type HttpMethod = 'get' | 'post' | 'put' | 'patch' | 'delete';

type DocOperation = {
  summary?: string;
  security?: readonly unknown[];
  parameters?: readonly {
    name: string;
    in: string;
    required?: boolean;
    example?: unknown;
    schema?: { type?: string; format?: string };
  }[];
  requestBody?: {
    content?: {
      'application/json'?: {
        example?: unknown;
      };
    };
  };
  responses?: Record<string, { description?: string }>;
};

@Controller()
export class DocsController {
  @Public()
  @Get('openapi.json')
  getOpenApiDocument() {
    return openApiDocument;
  }

  @Public()
  @Get('docs')
  @Header('Content-Type', 'text/html; charset=utf-8')
  getDocs() {
    const endpointGroups = this.renderEndpointGroups();

    return `<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Majadigi Backend API</title>
    <style>
      :root {
        color-scheme: light;
        --bg: #f6f8fb;
        --panel: #ffffff;
        --ink: #111827;
        --muted: #667085;
        --line: #d9e0ea;
        --brand: #155eef;
        --brand-dark: #0b3b96;
        --green: #067647;
        --amber: #b54708;
        --red: #b42318;
        --code: #0b1220;
      }

      * { box-sizing: border-box; }
      html { scroll-behavior: smooth; }
      body {
        margin: 0;
        font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
        line-height: 1.55;
        color: var(--ink);
        background: var(--bg);
      }

      a { color: var(--brand); text-decoration: none; }
      a:hover { text-decoration: underline; }
      code {
        padding: 2px 6px;
        border-radius: 6px;
        background: #eef3ff;
        color: var(--brand-dark);
        font-size: 0.92em;
      }
      pre {
        margin: 12px 0 0;
        padding: 16px;
        overflow: auto;
        border-radius: 8px;
        background: var(--code);
        color: #e5edf8;
        font-size: 13px;
        line-height: 1.55;
      }

      .shell {
        display: grid;
        grid-template-columns: 280px minmax(0, 1fr);
        min-height: 100vh;
      }
      .sidebar {
        position: sticky;
        top: 0;
        height: 100vh;
        padding: 28px 22px;
        border-right: 1px solid var(--line);
        background: #ffffff;
        overflow: auto;
      }
      .brand {
        display: flex;
        align-items: center;
        gap: 12px;
        margin-bottom: 28px;
      }
      .mark {
        display: grid;
        place-items: center;
        width: 40px;
        height: 40px;
        border-radius: 8px;
        background: var(--brand);
        color: #fff;
        font-weight: 800;
      }
      .brand-title { font-weight: 800; letter-spacing: 0; }
      .brand-subtitle { color: var(--muted); font-size: 13px; }
      .nav-title {
        margin: 24px 0 8px;
        color: #344054;
        font-size: 12px;
        font-weight: 800;
        text-transform: uppercase;
      }
      .nav-link {
        display: block;
        padding: 7px 0;
        color: #344054;
        font-size: 14px;
      }
      .main {
        padding: 36px;
      }
      .hero {
        padding: 30px;
        border: 1px solid var(--line);
        border-radius: 8px;
        background: var(--panel);
      }
      .eyebrow {
        margin: 0 0 8px;
        color: var(--brand);
        font-size: 13px;
        font-weight: 800;
        text-transform: uppercase;
      }
      h1 {
        margin: 0;
        font-size: 36px;
        line-height: 1.15;
        letter-spacing: 0;
      }
      h2 {
        margin: 34px 0 14px;
        font-size: 22px;
        letter-spacing: 0;
      }
      h3 {
        margin: 0 0 10px;
        font-size: 18px;
        letter-spacing: 0;
      }
      .lead {
        max-width: 820px;
        color: var(--muted);
        font-size: 16px;
      }
      .meta-grid {
        display: grid;
        grid-template-columns: repeat(3, minmax(0, 1fr));
        gap: 12px;
        margin-top: 24px;
      }
      .meta-card, .section-card, .endpoint-card {
        border: 1px solid var(--line);
        border-radius: 8px;
        background: var(--panel);
      }
      .meta-card { padding: 16px; }
      .meta-label {
        color: var(--muted);
        font-size: 12px;
        font-weight: 700;
        text-transform: uppercase;
      }
      .meta-value {
        margin-top: 4px;
        font-weight: 700;
      }
      .section-card {
        padding: 22px;
        margin-top: 14px;
      }
      .steps {
        display: grid;
        grid-template-columns: repeat(3, minmax(0, 1fr));
        gap: 14px;
      }
      .step {
        padding: 16px;
        border: 1px solid var(--line);
        border-radius: 8px;
        background: #fbfcff;
      }
      .step-number {
        display: inline-grid;
        place-items: center;
        width: 24px;
        height: 24px;
        margin-bottom: 10px;
        border-radius: 999px;
        background: #eaf1ff;
        color: var(--brand);
        font-size: 12px;
        font-weight: 800;
      }
      .endpoint-group {
        margin-top: 22px;
      }
      .endpoint-card {
        margin-top: 12px;
        overflow: hidden;
      }
      .endpoint-head {
        display: grid;
        grid-template-columns: auto minmax(0, 1fr) auto;
        gap: 12px;
        align-items: center;
        padding: 16px 18px;
        border-bottom: 1px solid var(--line);
      }
      .method {
        min-width: 58px;
        padding: 5px 8px;
        border-radius: 6px;
        color: #fff;
        font-size: 12px;
        font-weight: 800;
        text-align: center;
      }
      .method.get { background: var(--green); }
      .method.post { background: var(--brand); }
      .method.patch { background: var(--amber); }
      .method.put { background: #6941c6; }
      .method.delete { background: var(--red); }
      .path {
        overflow-wrap: anywhere;
        font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
        font-size: 14px;
        font-weight: 700;
      }
      .auth {
        padding: 4px 9px;
        border-radius: 999px;
        background: #f2f4f7;
        color: #344054;
        font-size: 12px;
        font-weight: 700;
        white-space: nowrap;
      }
      .auth.secure {
        background: #fff4e5;
        color: var(--amber);
      }
      .endpoint-body {
        padding: 16px 18px 18px;
      }
      .summary {
        margin: 0 0 12px;
        color: #344054;
      }
      .detail-grid {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 14px;
      }
      .detail-title {
        color: var(--muted);
        font-size: 12px;
        font-weight: 800;
        text-transform: uppercase;
      }
      .pill-list {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;
        margin-top: 8px;
      }
      .pill {
        padding: 5px 8px;
        border: 1px solid var(--line);
        border-radius: 999px;
        background: #ffffff;
        color: #344054;
        font-size: 12px;
      }
      .response-list {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;
        margin-top: 8px;
      }
      .status {
        padding: 5px 8px;
        border-radius: 6px;
        background: #ecfdf3;
        color: var(--green);
        font-size: 12px;
        font-weight: 800;
      }
      .status.error {
        background: #fef3f2;
        color: var(--red);
      }
      .example {
        margin-top: 14px;
      }
      .footer {
        margin: 36px 0 8px;
        color: var(--muted);
        font-size: 13px;
      }

      @media (max-width: 980px) {
        .shell { grid-template-columns: 1fr; }
        .sidebar { position: static; height: auto; }
        .main { padding: 22px; }
        .meta-grid, .steps, .detail-grid { grid-template-columns: 1fr; }
        .endpoint-head { grid-template-columns: 1fr; }
      }
    </style>
  </head>
  <body>
    <div class="shell">
      <aside class="sidebar">
        <div class="brand">
          <div class="mark">M</div>
          <div>
            <div class="brand-title">Majadigi API</div>
            <div class="brand-subtitle">Capstone backend contract</div>
          </div>
        </div>

        <div class="nav-title">Guide</div>
        <a class="nav-link" href="#overview">Overview</a>
        <a class="nav-link" href="#quick-start">Quick Start</a>
        <a class="nav-link" href="#auth">Authentication</a>
        <a class="nav-link" href="#endpoints">Endpoint Catalog</a>

        <div class="nav-title">Modules</div>
        <a class="nav-link" href="#group-gateway">Gateway</a>
        <a class="nav-link" href="#group-auth">Auth</a>
        <a class="nav-link" href="#group-profile">Profile</a>
        <a class="nav-link" href="#group-bapenda">Bapenda</a>
        <a class="nav-link" href="#group-rsud">RSUD</a>
        <a class="nav-link" href="#group-bansos">Bansos</a>
        <a class="nav-link" href="#group-hoaks">Hoaks</a>
        <a class="nav-link" href="#group-emergency">Emergency</a>
        <a class="nav-link" href="#group-islamic-center">Islamic Center</a>
        <a class="nav-link" href="#group-point-jatim">Point Jatim</a>
        <a class="nav-link" href="#group-tbc-screening">TBC Screening</a>
        <a class="nav-link" href="#group-tickets">Tickets</a>
      </aside>

      <main class="main">
        <section class="hero" id="overview">
          <p class="eyebrow">Version ${openApiDocument.info.version}</p>
          <h1>Majadigi Backend API</h1>
          <p class="lead">
            Integration contract for the Majadigi Flutter capstone app. Use this page for manual integration,
            quick smoke testing, and checking which endpoints require a Bearer token.
          </p>
          <div class="meta-grid">
            <div class="meta-card">
              <div class="meta-label">Base URL</div>
              <div class="meta-value"><code>${openApiDocument.servers[0].url}</code></div>
            </div>
            <div class="meta-card">
              <div class="meta-label">OpenAPI</div>
              <div class="meta-value"><a href="/openapi.json">/openapi.json</a></div>
            </div>
            <div class="meta-card">
              <div class="meta-label">Demo Account</div>
              <div class="meta-value"><code>demo@majadigi.go.id</code></div>
            </div>
          </div>
        </section>

        <section id="quick-start">
          <h2>Quick Start</h2>
          <div class="section-card">
            <div class="steps">
              <div class="step">
                <div class="step-number">1</div>
                <h3>Choose base URL</h3>
                <p>Local browser, iOS simulator, desktop, and web use <code>http://localhost:3000</code>.</p>
                <p>Android emulator uses <code>http://10.0.2.2:3000</code>.</p>
              </div>
              <div class="step">
                <div class="step-number">2</div>
                <h3>Login</h3>
                <p>POST to <code>/auth/login</code> using the demo account to receive a signed JWT.</p>
                <pre class="curl">curl -X POST http://localhost:3000/auth/login \\
  -H "Content-Type: application/json" \\
  -d '{"email":"demo@majadigi.go.id","password":"password"}'</pre>
              </div>
              <div class="step">
                <div class="step-number">3</div>
                <h3>Call private APIs</h3>
                <p>Send <code>Authorization: Bearer &lt;access_token&gt;</code> on endpoints marked Bearer token.</p>
                <pre class="curl">curl http://localhost:3000/profile/me \\
  -H "Authorization: Bearer &lt;access_token&gt;"</pre>
              </div>
            </div>
          </div>
        </section>

        <section id="auth">
          <h2>Authentication</h2>
          <div class="section-card">
            <p>
              Public endpoints can be called without headers. Protected endpoints require a signed JWT from
              <code>/auth/login</code>. Invalid, missing, or expired tokens return <code>401</code>; invalid JSON
              payloads return <code>400</code>.
            </p>
          </div>
        </section>

        <section id="endpoints">
          <h2>Endpoint Catalog</h2>
          ${endpointGroups}
        </section>

        <p class="footer">Generated from the backend OpenAPI contract. Machine-readable JSON remains available at <a href="/openapi.json">/openapi.json</a>.</p>
      </main>
    </div>
  </body>
</html>`;
  }

  private renderEndpointGroups() {
    const grouped = new Map<string, string[]>();
    const paths = Object.entries(openApiDocument.paths) as Array<[string, Partial<Record<HttpMethod, DocOperation>>]>;

    for (const [path, operations] of paths) {
      const group = this.getGroupName(path);
      const cards = grouped.get(group) ?? [];

      for (const [method, operation] of Object.entries(operations) as Array<[HttpMethod, DocOperation]>) {
        cards.push(this.renderEndpointCard(method, path, operation));
      }

      grouped.set(group, cards);
    }

    return Array.from(grouped.entries())
      .map(([group, cards]) => {
        const id = `group-${group.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/(^-|-$)/g, '')}`;
        return `<div class="endpoint-group" id="${id}">
          <h3>${this.escapeHtml(group)}</h3>
          ${cards.join('')}
        </div>`;
      })
      .join('');
  }

  private renderEndpointCard(method: HttpMethod, path: string, operation: DocOperation) {
    const requiresAuth = Boolean(operation.security?.length);
    const parameters = operation.parameters ?? [];
    const responses = Object.entries(operation.responses ?? {});
    const requestExample = operation.requestBody?.content?.['application/json']?.example;

    return `<article class="endpoint-card">
      <div class="endpoint-head">
        <span class="method ${method}">${method.toUpperCase()}</span>
        <span class="path">${this.escapeHtml(path)}</span>
        <span class="auth ${requiresAuth ? 'secure' : ''}">${requiresAuth ? 'Bearer token' : 'Public'}</span>
      </div>
      <div class="endpoint-body">
        <p class="summary">${this.escapeHtml(operation.summary ?? 'No summary provided.')}</p>
        <div class="detail-grid">
          <div>
            <div class="detail-title">Parameters</div>
            ${
              parameters.length
                ? `<div class="pill-list">${parameters
                    .map((parameter) => `<span class="pill">${this.escapeHtml(parameter.name)} ${parameter.required ? '(required)' : ''}</span>`)
                    .join('')}</div>`
                : '<div class="pill-list"><span class="pill">None</span></div>'
            }
          </div>
          <div>
            <div class="detail-title">Responses</div>
            <div class="response-list">
              ${responses
                .map(([status, response]) => `<span class="status ${Number(status) >= 400 ? 'error' : ''}">${status} ${this.escapeHtml(response.description ?? '')}</span>`)
                .join('')}
            </div>
          </div>
        </div>
        ${
          requestExample
            ? `<div class="example">
                <div class="detail-title">Request Example</div>
                <pre class="json">${this.escapeHtml(JSON.stringify(requestExample, null, 2))}</pre>
              </div>`
            : ''
        }
      </div>
    </article>`;
  }

  private getGroupName(path: string) {
    const segment = path.split('/').filter(Boolean)[0] ?? 'general';
    const names: Record<string, string> = {
      gateway: 'Gateway',
      auth: 'Auth',
      profile: 'Profile',
      bapenda: 'Bapenda',
      rsud: 'RSUD',
      bansos: 'Bansos',
      hoaks: 'Hoaks',
      emergency: 'Emergency',
      'islamic-center': 'Islamic Center',
      'point-jatim': 'Point Jatim',
      'tbc-screening': 'TBC Screening',
      tickets: 'Tickets',
    };
    return names[segment] ?? 'General';
  }

  private escapeHtml(value: unknown) {
    return String(value)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#039;');
  }
}
