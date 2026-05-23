import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../../core/theme/app_colors.dart";
import "providers/auth_provider.dart";

enum AuthMode { login, register, phone }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthMode _mode = AuthMode.login;
  bool _loading = false;
  String _error = '';

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();

  @override void dispose() {
    _emailCtrl.dispose(); _passwordCtrl.dispose();
    _nameCtrl.dispose(); _phoneCtrl.dispose(); _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() { _error = ''; _loading = true; });
    final auth = context.read<AuthProvider>();
    bool ok = false;

    try {
      switch (_mode) {
        case AuthMode.login:
          ok = await auth.loginWithEmail(_emailCtrl.text.trim(), _passwordCtrl.text);
          break;
        case AuthMode.register:
          ok = await auth.register(_emailCtrl.text.trim(), _passwordCtrl.text, _nameCtrl.text.trim());
          break;
        case AuthMode.phone:
          ok = await auth.loginWithPhone(_phoneCtrl.text.trim(), _codeCtrl.text.trim());
          break;
      }
    } catch (_) {
      _error = '网络错误，请重试';
    }

    if (!ok && _error.isEmpty) {
      _error = _mode == AuthMode.phone ? '验证码错误（测试码: 123456）' : '邮箱或密码错误（密码需6位以上）';
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(children: [
            const SizedBox(height: 60),
            // Logo
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: AppColors.gradientBreathing),
              ),
              child: const Icon(Icons.self_improvement, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 24),
            Text('息心', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('中文原生正念冥想', style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 48),

            // Mode tabs
            Row(children: [
              _tab('邮箱登录', AuthMode.login),
              _tab('注册', AuthMode.register),
              _tab('手机登录', AuthMode.phone),
            ]),
            const SizedBox(height: 32),

            // Form fields
            if (_mode != AuthMode.phone) ...[
              _buildField(_emailCtrl, '邮箱', Icons.email_outlined, TextInputType.emailAddress),
              const SizedBox(height: 16),
            ],
            if (_mode == AuthMode.register) ...[
              _buildField(_nameCtrl, '昵称', Icons.person_outline, TextInputType.text),
              const SizedBox(height: 16),
            ],
            if (_mode == AuthMode.phone) ...[
              _buildField(_phoneCtrl, '手机号', Icons.phone_android, TextInputType.phone, hint: '输入11位手机号'),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: _buildField(_codeCtrl, '验证码', Icons.pin, TextInputType.number)),
                const SizedBox(width: 12),
                TextButton(onPressed: () {}, child: const Text('获取验证码')),
              ]),
            ],
            if (_mode != AuthMode.phone) ...[
              _buildField(_passwordCtrl, '密码', Icons.lock_outline, TextInputType.visiblePassword, obscure: true),
            ],
            const SizedBox(height: 8),

            // Error
            if (_error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(_error, style: const TextStyle(color: AppColors.error, fontSize: 13)),
              ),

            // Submit
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(_mode == AuthMode.register ? '注册并开始免费试用' : '登录', style: const TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 24),

            // Skip
            TextButton(
              onPressed: () => context.read<AuthProvider>().skipLogin(),
              child: Text('跳过登录，随便看看', style: TextStyle(color: AppColors.textSecondary)),
            ),
            const SizedBox(height: 16),

            // Benefit
            if (_mode == AuthMode.register)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.accent.withValues(alpha: 0.1),
                ),
                child: const Row(children: [
                  Icon(Icons.card_giftcard, color: AppColors.accent, size: 20),
                  SizedBox(width: 8),
                  Expanded(child: Text('注册即享 7 天免费会员，解锁全部高级内容', style: TextStyle(color: AppColors.accent, fontSize: 13))),
                ]),
              ),
            const SizedBox(height: 32),
          ]),
        ),
      ),
    );
  }

  Widget _tab(String label, AuthMode mode) {
    final active = _mode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _mode = mode),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: active ? AppColors.primary : Colors.transparent, width: 2)),
          ),
          child: Text(label, textAlign: TextAlign.center,
            style: TextStyle(color: active ? AppColors.primary : AppColors.textSecondary, fontWeight: active ? FontWeight.w600 : FontWeight.w400)),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String label, IconData icon, TextInputType type, {String? hint, bool obscure = false}) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}