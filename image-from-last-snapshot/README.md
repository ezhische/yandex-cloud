Скрипт создаёт виртуальную машину, запускает на ней копирование системного диска в S3 и после завершения уничтожает машину  
Необходимо заполнить настройки подключения к облаку.   
В файле cloudinit.yaml заполнить Ключи для доступа к Object Storage и имя бакета   
В файле start-backup.sh ID диска с которого делаются снепшоты.  
В файле main.tf неодимо заполнить настройки подключения и ID подсети  
Должен быть настроен yc cli.  
Должен быть установлен terraform  
Запускать скрипт start-backup.sh  
Скрипт copy.sh копирует образ локально и преобразует в формат Qcow2.
