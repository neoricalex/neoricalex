/*
 * =====================================================================================
 *
 *       Filename:  neoricalex.c
 *
 *    Description:  neoricalex
 *
 *        Version:  1.0
 *        Created:  01/15/2013 03:40:34 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *   Organization:  
 *
 * =====================================================================================
 */
 
#include <stdlib.h>
#include <stdio.h> 

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  main
 *  Description:  
 * =====================================================================================
 */

int
main ( int argc, char *argv[] )
{
    puts("Bem-vindo(a) ao " PACKAGE_STRING " !");
    puts("================================\n");

	int iniciar_sessao = system("cd src; chmod +x iniciar_sessao.sh; ./iniciar_sessao.sh");
	return EXIT_SUCCESS;
}	
/* ----------  end of function main  ---------- */
