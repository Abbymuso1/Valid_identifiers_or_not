%{
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <regex.h>
%}

%option noyywrap

%{
bool check_valid_identifier(const char *identifier) {
    regex_t regex;
    int ret;

    // Define the regular expression pattern for a valid identifier
    const char *identifier_pattern = "^[A-Za-z_][A-Za-z0-9_]*$";

    // Compile the regular expression
    ret = regcomp(&regex, identifier_pattern, REG_EXTENDED);

    if (ret) {
        fprintf(stderr, "Failed to compile regex\n");
        exit(EXIT_FAILURE);
    }

    // Check if the identifier matches the pattern
    if (regexec(&regex, identifier, 0, NULL, 0) == 0) {
        regfree(&regex);
        return true;
    } else {
        regfree(&regex);
        return false;
    }
}
%}

%%

"def check_valid_identifier(identifier):" {
    /* Start of the check_valid_identifier function */
    printf("Validating identifiers...\n");
}

"return True" {
    /* Return True found, this is a valid identifier */
    printf("True\n");
}

"return False" {
    /* Return False found, this is not a valid identifier */
    printf("False\n");
}

[ \t]+ {
    /* Ignore spaces and tabs */
}

.|\n {
    /* Ignore other characters */
}

%%

int main() {
    yylex();
    return 0;
}