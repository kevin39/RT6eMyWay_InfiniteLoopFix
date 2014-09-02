/*
 * RT6_POIFIX.CMD
 * by Kevin (based on RT6_DISKCOPY & RT6_FILECOPY, see credits)
 * Original public release for WWW.PLANETE-CITROEN.COM
 * Now public for everyone.
 *
 * Fix infinite loop on POI update
 * ver:01.00  30/03/2013 :  first release
 * ver:01.01  02/04/2013 :  minor changes
 * ver:02.00  05/04/2013 :  optimizations, code cleaning
 * ver:02.01  06/04/2013 :  some other optimizations
 *
 * Credits : 
 * http://mira308sw.altervista.org/
 * Thanks a lot Mira!
 */

/*** GLOBAL DEFINES ****/

// Script Types
typedef int  STATUS;
typedef void FILE;

#define TRUE            (1)
#define FALSE           (0)
#define OK              (0)
#define ERROR           (-1)
#define NULL            (void*) 0

// Drive letters
#define DRIVE_NAV       "/SDH/MAPPE/POI_USER"

// POI TEMP DIR
#define POI_TEMP_PREFIX "/TEMP"

/*** EXTERN FUNCTION DECLARATIONS ***/

// File operations
STATUS UPGDelete          (char* fn);
int    UPGSearchFile      (char* Filename, char *RootDir, char *Param, char *TableDir );
STATUS UPGGetSearchResult (int index , char *SearchResult );
STATUS GetFileSize        (char* file, int *size);

int    fputs              (char* s, FILE * fp);
FILE*  fopen              (char* filename, char * mode );
int    fclose             (FILE* fp);

// String operations
char*  strstr             (char* str, char* substr);
STATUS strcpy             (char* target, char* source);
STATUS strcat             (char* target, char* source);

// MMI UPG Panel management
STATUS ClearScreen                  (void);
STATUS ShowNavigationBargraph       (void);
STATUS StepBargraph                 (char *text, int index);
STATUS ShowNavigationQuestionScreen (char *text, int *answer);

// Others
STATUS taskDelay          (int ticks);

/****************************** POIFIX ******************************/
#define YES                     (1)
#define NO                      (0)
#define USB_POIUSER_FILELIST    "/bd0/POI_TEMP_FILES.TXT"

int PoiTempCleaner ( FILE* p_pList,char* p_pDrive )
{
  char l_sFile[256];
  char l_sText[256];
  int  l_nFile;
  int  l_iSize;
  int  l_i;
  int  l_iPerc;

  ShowNavigationBargraph();
  strcpy( l_sText,"Reading POI" );
  StepBargraph( l_sText,0 );

  l_nFile=UPGSearchFile( "*.*",p_pDrive,NULL,NULL );
  l_iPerc=l_nFile/10;
  for( l_i=0 ; l_i<l_nFile ; )
  {
    if( UPGGetSearchResult( l_i,l_sFile )==ERROR )
      l_i++;
    else
    {
     	if(GetFileSize( l_sFile,&l_iSize )!=ERROR && strstr( l_sFile, POI_TEMP_PREFIX )!=NULL)
     	{
     		fputs( l_sFile,p_pList );
    		// Found a temporary file, delete it !
    		UPGDelete(l_sFile);
    		fputs( l_sFile,p_pList );
    		fputs( "\r\n",p_pList );
     	}
     	l_i++;
     	if( l_i>=l_iPerc )
     	{
     	  StepBargraph( l_sText,100*l_i/l_nFile );
     	  l_iPerc+=l_nFile/10;
     	}
    }
  }
  strcat( l_sText," temp files... " );
  StepBargraph( l_sText,100 );
  taskDelay( 1000 );
  return OK;
}

int poifix ( void )
{
  int   l_iAnsw;
  FILE* l_pList;
  int	returnState;
  
  l_pList=fopen( USB_POIUSER_FILELIST,"wb" );
  if( l_pList==NULL )
    return ERROR;
  ShowNavigationQuestionScreen( "Confirm run POIFIX ?",&l_iAnsw );
  if( l_iAnsw==YES )
  	PoiTempCleaner( l_pList,DRIVE_NAV );
  fclose( l_pList );
  ShowNavigationBargraph();
  StepBargraph( "Cleaning done!",100 );
  taskDelay( 1000 );
  return OK;
}

int main ( int argc, char **argv )
{
  int  l_iAnsw = FALSE;

  poifix();
  ShowNavigationQuestionScreen( "POIFIX completed!",&l_iAnsw );
  ClearScreen();
  return OK;
}


// SVN_INFO:NGI2Njc4NmM3MjNkM2MzOTNhMzY1YTVhNTU1MzU3Njc2ZjY3NDQ0MDRiNGU0NDQ4NGE0ZTQ4NGM0ZTUzNGM1MDUxNWE=