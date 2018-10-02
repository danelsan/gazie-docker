Perché Gazie-Docker
-------------------

Con Gazie-Docker puoi installare l'ultima versione
stabile di Gazie in meno di 10 minuti.

Hai la tua infrastruttura Gazie con NGINX, PHP-FPM e database MARIADB.


Installazione
------------

Per l'installazione occorre in primo luogo avere installato
l'applicativo docker

https://www.docker.com/


Modificare il file di configurazione

conf

ed eseguire il build per creare le immagini Gazie-Docker, Gazie-Nginx

./build.sh

Potete per esempio lavorare sul vostro pc senza installare mysql o php, ma semplicemente docker.

Esecuzione Immagini Docker
--------------------------

Per eseguire le immagini docker create scrivere

./start.sh

Per stoppare le immagini docker eseguire

./stop.sh


Restore Database di Backup
--------------------------

Se hai un backup da ripristinare puoi semplicemente editare:

./restore [ file-dump-gzip ]

Il comando ripristina il database sul database Mariadb.


