Текст пароля шифруется ключом из KMS хранилища. Для шифрования используется скрипт  
enrypt-password.ps1 -Password Пароль -KeyID ID_KSM_ключа
Должен быть установлен и настроен yc cli с правами аккаунта включающими роль kms.keys.encrypterDecrypter  
Создаваемой машине назначается аккаунт с ролью kms.keys.encrypterDecrypter  
