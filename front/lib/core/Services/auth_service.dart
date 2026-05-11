// =====================================================================
// Servicio de autenticacion
// =====================================================================
// Su unica responsabilidad: hablar con los endpoints de autenticacion
// y gestionar el almacenamiento seguro del token.
//
// Aqui se materializa la regla del documento teorico:
// "el token se guarda en lugar seguro".
// FlutterSecureStorage usa el sistema cifrado del SO:
//   - Android: EncryptedSharedPreferences
//   - iOS: Keychain
// NUNCA guardar el token en SharedPreferences normales.
// =====================================================================

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // Instancia del almacenamiento seguro
  final _storage = const FlutterSecureStorage();

  // Claves para el almacenamiento
  static const _kTokenKey    = 'access_token';
  static const _kNombreKey   = 'nombre_usuario';

  // -------------------------------------------------------------------
  // Guardar el token y el nombre despues del login exitoso
  // -------------------------------------------------------------------
  Future<void> guardarSesion({
    required String token,
    required String nombreUsu,
  }) async {
    await _storage.write(key: _kTokenKey,  value: token);
    await _storage.write(key: _kNombreKey, value: nombreUsu);
  }

  // -------------------------------------------------------------------
  // Leer el token guardado (lo usan los servicios para inyectarlo
  // en el header Authorization: Bearer de cada peticion protegida)
  // -------------------------------------------------------------------
  Future<String?> getToken() async {
    return await _storage.read(key: _kTokenKey);
  }

  // -------------------------------------------------------------------
  // Verificar si hay sesion activa
  // -------------------------------------------------------------------
  Future<bool> haySesion() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // -------------------------------------------------------------------
  // Obtener el nombre guardado
  // -------------------------------------------------------------------
  Future<String?> getNombre() async {
    return await _storage.read(key: _kNombreKey);
  }

  // -------------------------------------------------------------------
  // Cerrar sesion: borrar el token del almacenamiento
  // -------------------------------------------------------------------
  // El servidor no hace nada: el token expira solo.
  // El cliente es el responsable de "olvidar" el token.
  Future<void> logout() async {
    await _storage.delete(key: _kTokenKey);
    await _storage.delete(key: _kNombreKey);
  }
}