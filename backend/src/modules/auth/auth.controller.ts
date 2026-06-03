import { Body, Controller, Get, Patch, Post, Req } from '@nestjs/common';
import { Public } from '../../common/decorators/public.decorator';
import { ForgotPasswordDto, LoginDto, RegisterDto, UpdateFavoritesDto, UpdateProfileDto, VerifyEmailDto } from './auth.dto';
import { AuthService } from './auth.service';

@Controller()
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Public()
  @Post('auth/register')
  register(@Body() body: RegisterDto) {
    return this.authService.register(body);
  }

  @Public()
  @Post('auth/login')
  login(@Body() body: LoginDto) {
    return this.authService.login(body.email, body.password);
  }

  @Get('profile/me')
  getProfile(@Req() request: { user: { nik: string } }) {
    return this.authService.getProfileByNik(request.user.nik);
  }

  @Patch('profile/me')
  updateProfile(@Req() request: { user: { nik: string } }, @Body() body: UpdateProfileDto) {
    return this.authService.updateProfile(request.user.nik, body);
  }

  @Patch('profile/favorites')
  updateFavorites(
    @Req() request: { user: { nik: string } },
    @Body() body: UpdateFavoritesDto,
  ) {
    return this.authService.updateFavorites(request.user.nik, body.service_keys);
  }

  @Public()
  @Post('auth/forgot-password')
  forgotPassword(@Body() body: ForgotPasswordDto) {
    return this.authService.forgotPassword(body.email);
  }

  @Public()
  @Post('auth/verify-email')
  verifyEmail(@Body() body: VerifyEmailDto) {
    return this.authService.verifyEmail(body.email, body.code);
  }
}
