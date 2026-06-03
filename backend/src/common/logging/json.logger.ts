import { ConsoleLogger, Injectable, LogLevel } from '@nestjs/common';
import * as winston from 'winston';

@Injectable()
export class JsonLogger extends ConsoleLogger {
  private readonly winstonLogger = winston.createLogger({
    level: process.env.LOG_LEVEL ?? 'info',
    format: winston.format.combine(winston.format.timestamp(), winston.format.json()),
    transports: [new winston.transports.Console()],
  });

  log(message: unknown, context?: string) {
    this.write('info', message, context);
  }

  error(message: unknown, stack?: string, context?: string) {
    this.winstonLogger.error({ context, message, stack });
  }

  warn(message: unknown, context?: string) {
    this.write('warn', message, context);
  }

  debug(message: unknown, context?: string) {
    this.write('debug', message, context);
  }

  verbose(message: unknown, context?: string) {
    this.write('verbose', message, context);
  }

  private write(level: LogLevel | 'info', message: unknown, context?: string) {
    this.winstonLogger.log(level === 'log' ? 'info' : level, { context, message });
  }
}
