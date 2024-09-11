/*
 * main.c
 *  Example mPower custom application. 
 *
 *  Cross compile, package, and install.
 */

#include <assert.h>
#include <stdio.h>
#include <syslog.h>
#include <stdarg.h>
#include <unistd.h>
#include <stdlib.h>

//Logger identification.
#define LOG_IDENT "c_example"

//Maximum length of a configuration file path.
#define BUF_LEN 255

/*
 * log_info()
 */
void log_info(char *format, ...) {
    va_list args;
    va_start(args, format);
    vsyslog(LOG_INFO, format, args);
    va_end(args);
}


/*
 * creadln()
 *  Reads file until LF character or bufsz - 1 bytes.
 *
 * Returns:
 *  NULL terminated string in str not including LF.
 *  Number of bytes read not including NULL terminator.
 *
 */
int creadln(char *str, int strsz, FILE *f) {
    char buf = 0x00;
    int  maxlen = strsz - 1;
    int  retval = 0;
    int  i = 0;

    assert(NULL != str);
    assert(strsz > 0);
    assert(NULL != f);

    for(i = 0; i < maxlen; ++i) {
        retval = fread(&buf, 1, 1, f);
        if(1 == retval) {
            if('\n' == buf) {
                break;
            }
            str[i] = buf;
        } else {
            break;
        }
    }

    str[i] = 0x00;
    return i;
}


int main(int argc, char *argv[]) {
    int  lineno         = 0;
    int  opt            = 0;
    FILE *f             = NULL;
    char line[BUF_LEN]  = {0x00};

    openlog(LOG_IDENT, LOG_PERROR, LOG_DAEMON);

    log_info("Begin application...");

    //Get configuration file name from '-c' argument.
    while ((opt = getopt(argc, argv, "c:")) != -1) {
        switch (opt) {
            case 'c':
                log_info("Opening configuration file \"%s\"...", optarg);
                f = fopen(optarg, "rb");
                if(NULL != f) {
                    log_info("Loading configuration file...");
                    for(lineno = 1; lineno < BUF_LEN; ++lineno) {
                        if(creadln(line, BUF_LEN, f) < 1) {
                            break;
                        } else {
                            log_info("[%i] %s", lineno, line);
                        }
                    }
                    log_info("Configuration file loaded.");
                    log_info("Closing configuration file...");
                    fclose(f);
                    f = NULL;
                    log_info("Configuration file closed.");
                } else {
                    log_info("Opening configuration file failed.");
                }
            break;

            case ':':
            case '?':
            exit(EXIT_FAILURE);

            default:
            break;
        }
    }

    log_info("End application.");
    return(EXIT_SUCCESS);
}
