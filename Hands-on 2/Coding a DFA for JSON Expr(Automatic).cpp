#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int isAlphaNumValid(const char *s) {
    if (!isalpha(*s)) return 0; //Debe empezar con una letra
    for (int i = 1; s[i]; i++) {
        if (!isalnum(s[i])) return 0; //El resto deben ser letras o números
    }
    return 1;
}

int validarJSON(const char *input) {
    char buffer[10000];
    int j = 0;
    for (int i = 0; input[i]; i++) {
        if (!isspace(input[i])) buffer[j++] = input[i]; //Quita espacios
    }
    buffer[j] = '\0';

    if (strncmp(buffer, "{\"employees\":[", 14) != 0) {
        return 0;
    }
    int pos = 14;
    int instancia = 0;

    while (buffer[pos] == '{') {
        pos++;
        instancia++;

        if (strncmp(&buffer[pos], "\"firstName\":\"", 13) != 0) return 0;
        pos += 13;

        char fname[100];
        int k = 0;
        while (buffer[pos] != '"') {
            if (buffer[pos] == '\0') return 0;
            fname[k++] = buffer[pos++];
        }
        fname[k] = '\0';
        pos++;
        if (!isAlphaNumValid(fname)) return 0;

        if (buffer[pos++] != ',') return 0;

        if (strncmp(&buffer[pos], "\"lastName\":\"", 12) != 0) return 0;
        pos += 12;

        char lname[100];
        k = 0;
        while (buffer[pos] != '"') {
            if (buffer[pos] == '\0') return 0;
            lname[k++] = buffer[pos++];
        }
        lname[k] = '\0';
        pos++;
        if (!isAlphaNumValid(lname)) return 0;

        if (buffer[pos++] != '}') return 0;

        if (buffer[pos] == ',') {
            pos++;
            continue;
        } else if (buffer[pos] == ']') {
            break;
        } else {
            return 0;
        }
    }

    if (buffer[pos++] != ']') return 0;
    if (buffer[pos++] != '}') return 0;
    if (buffer[pos] != '\0') return 0;

    return 1;
}

int main() {
    char firstName[100], lastName[100];
    char json[10000];
    char buffer[1000];
    int instancia = 0;
    char continuar;

    //Inicializa JSON
    strcpy(json, "{\n\"employees\":[\n");

    do {
        printf("Ingrese firstName: ");
        scanf("%99s", firstName);

        printf("Ingrese lastName: ");
        scanf("%99s", lastName);

        //Valida cada entrada
        if (!isAlphaNumValid(firstName)) {
            printf("? Error: firstName invalido (%s)\n", firstName);
            return 1;
        }
        if (!isAlphaNumValid(lastName)) {
            printf("? Error: lastName invalido (%s)\n", lastName);
            return 1;
        }

        //Agrega instancias al JSON
        if (instancia > 0) {
            strcat(json, ",\n");
        }
        sprintf(buffer, "{\"firstName\":\"%s\",\"lastName\":\"%s\"}", firstName, lastName);
        strcat(json, buffer);

        instancia++;

        //Pregunta si continua
        printf("¿Desea agregar otra instancia? (s/n): ");
        scanf(" %c", &continuar);

    } while (continuar == 's' || continuar == 'S');

    //Cierra JSON
    strcat(json, "\n]\n}");

    printf("\nJSON generado con %d instancia(s):\n", instancia);
    printf("%s\n", json);

    if (validarJSON(json)) {
        printf("\n? El JSON generado es válido ?\n");
    } else {
        printf("\n? El JSON generado NO es válido ?\n");
    }

    return 0;
}

