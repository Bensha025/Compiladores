#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int isAlphaNumValid(const char *s) {
    if (!isalpha(*s)) return 0; //Debe empezar con letra
    for (int i = 1; s[i]; i++) {
        if (!isalnum(s[i])) return 0;
    }
    return 1;
}

int validarJSON(const char *input) {
    char buffer[10000];
    int j = 0;
    for (int i = 0; input[i]; i++) {
        if (!isspace(input[i])) buffer[j++] = input[i];
    }
    buffer[j] = '\0';

    if (strncmp(buffer, "{\"employees\":[", 14) != 0) {
        printf("Error: JSON debe comenzar con {\"employees\":[\n");
        return 0;
    }
    int pos = 14;
    int instancia = 0;

    while (buffer[pos] == '{') {
        pos++;
        instancia++;

        if (strncmp(&buffer[pos], "\"firstName\":\"", 13) != 0) {
            printf("Error en instancia %d: falta \"firstName\"\n", instancia);
            return 0;
        }
        pos += 13;

        char fname[100];
        int k = 0;
        while (buffer[pos] != '"') {
            if (buffer[pos] == '\0') return 0;
            fname[k++] = buffer[pos++];
        }
        fname[k] = '\0';
        pos++;
        if (!isAlphaNumValid(fname)) {
            printf("Error en instancia %d: firstName invalido (%s)\n", instancia, fname);
            return 0;
        }

        if (buffer[pos++] != ',') {
            printf("Error en instancia %d: falta coma tras firstName\n", instancia);
            return 0;
        }

        if (strncmp(&buffer[pos], "\"lastName\":\"", 12) != 0) {
            printf("Error en instancia %d: falta \"lastName\"\n", instancia);
            return 0;
        }
        pos += 12;

        char lname[100];
        k = 0;
        while (buffer[pos] != '"') {
            if (buffer[pos] == '\0') return 0;
            lname[k++] = buffer[pos++];
        }
        lname[k] = '\0';
        pos++;
        if (!isAlphaNumValid(lname)) {
            printf("Error en instancia %d: lastName invalido (%s)\n", instancia, lname);
            return 0;
        }

        if (buffer[pos++] != '}') {
            printf("Error en instancia %d: falta cierre }\n", instancia);
            return 0;
        }

        if (buffer[pos] == ',') {
            pos++;
            continue;
        } else if (buffer[pos] == ']') {
            break;
        } else {
            printf("Error: caracter inesperado tras instancia %d\n", instancia);
            return 0;
        }
    }

    if (buffer[pos++] != ']') return 0;
    if (buffer[pos++] != '}') return 0;
    if (buffer[pos] != '\0') return 0;

    printf("JSON valido con %d instancia(s)\n", instancia);
    return 1;
}

int main() {
    char input[10000];
    printf("Ingrese el JSON:\n");
    fgets(input, sizeof(input), stdin);

    if (validarJSON(input)) {
        printf("? JSON correcto\n");
    } else {
        printf("? JSON incorrecto\n");
    }
    return 0;
}

