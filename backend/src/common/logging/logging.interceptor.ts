import {
  CallHandler,
  ExecutionContext,
  Injectable,
  NestInterceptor,
} from '@nestjs/common';
import { Observable, tap } from 'rxjs';

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<unknown> {
    const startedAt = Date.now();
    const request = context.switchToHttp().getRequest();

    return next.handle().pipe(
      tap(() => {
        const durationMs = Date.now() - startedAt;
        console.info(
          JSON.stringify({
            timestamp: new Date().toISOString(),
            level: 'info',
            path: request.url,
            method: request.method,
            nik: request.user?.nik ?? null,
            ip: request.ip,
            duration_ms: durationMs,
          }),
        );
      }),
    );
  }
}
