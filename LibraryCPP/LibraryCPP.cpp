#include "stdafx.h"
#include "ClusApi.h"					// Cluster API. # Include <ClusApi.h> / / Cluster API.
#include "ResApi.h"                    // Resource API.


#define INFO_BUFFER_SIZE 32767

const int nBufferSize = 500;
//Nom des services
char pServiceName[nBufferSize + 1];
//Dependences
char pDependency[nBufferSize + 1];
//Nom du groupe cluster
char pClusterGroup[nBufferSize + 1];
//Nom de la ressource cluster
char pClusterResource[nBufferSize + 1];


// ------------------------------------------------------------------
// Fonction retournant l'état de la ressource cluster (du service)
// ------------------------------------------------------------------
void GetClusterState(WCHAR* groupClusterName, WCHAR* resourceClusterName, char *clusterState, char *errorMessage, int* returnCode)
{
	HCLUSTER hCluster = NULL;
	HGROUP hGroup = NULL;
	HRESOURCE hResource = NULL;

	TCHAR infoBuf[INFO_BUFFER_SIZE];
	DWORD bufCharCount = INFO_BUFFER_SIZE;
	DWORD cchNameSize = MAX_COMPUTERNAME_LENGTH + 1;
	//char pTemp[121];
	//char pState[50] = "Unknown state";
	DWORD dwState;
	DWORD cbGroupName = 0; // for GetClusterResourceState
	DWORD cbNodeName = 100; // for GetClusterResourceState

	LPWSTR lpszClusterName = (LPWSTR)LocalAlloc(LPTR, cchNameSize * sizeof(WCHAR));
	LPWSTR lpszClusterGrpName = (LPWSTR)LocalAlloc(LPTR, cchNameSize * sizeof(WCHAR));
	LPWSTR lpszNodeName = (LPWSTR)LocalAlloc(LPTR, cbNodeName * sizeof(WCHAR));

	long nError;
	*returnCode = 1;
	try
	{
		if (lpszClusterName != NULL)
		{
			*returnCode = 2;
			//  Get the name of the local node.
			//  Using a name instead of NULL in OpenCluster
			//  creates an RPC handle.

			bufCharCount = INFO_BUFFER_SIZE;

			*returnCode = 3;
			if (GetComputerName(infoBuf, &bufCharCount))
			{
				*returnCode = 4;
				/*sprintf(errorMessage, "Computer name : %s \n", infoBuf);*/
			
				hCluster = OpenCluster(lpszClusterName);
				*returnCode = 5;
				if (hCluster == NULL)
				{
					*returnCode = 6;
					nError = GetLastError();
					*returnCode = 7;
					sprintf(errorMessage, "cluster nof found, error code = %d \n", nError);
					*returnCode = 8;
				}
				else
				{
				
					*returnCode = 9;
					hGroup = OpenClusterGroup(hCluster, groupClusterName);
					*returnCode = 10;
					if (hGroup == NULL)
					{
						*returnCode = 11;
						nError = GetLastError();
						*returnCode = 12;
						sprintf(errorMessage, "unable to open the group, error code = %d \n", nError);
						//sprintf(errorMessage, "groupClusterName name : %s \n", name);
						*returnCode = 13;
					}
					else
					{
						*returnCode = 14;
						hResource = OpenClusterResource(hCluster, resourceClusterName);
						*returnCode = 15;
						if (hResource == NULL)
						{
							*returnCode = 16;
							nError = GetLastError();
							*returnCode = 17;
							sprintf(errorMessage, "unable to open resource, error code : %d \n", nError);
						}
						else
						{
							*returnCode = 18;
							dwState = GetClusterResourceState(hResource, lpszNodeName, &cbNodeName, NULL, &cbGroupName);
							*returnCode = 19;
							switch (dwState)
							{
							case ClusterResourceFailed:
								*returnCode = 20;
								sprintf(clusterState, "Failed");
								break;
							case ClusterResourceOnline:
								*returnCode = 21;
								sprintf(clusterState, "Online");
								break;
							case ClusterResourceOffline:
								*returnCode = 22;
								sprintf(clusterState, "Offline");
								break;
							case ClusterResourceInitializing:
								*returnCode = 23;
								sprintf(clusterState, "Initializing");
								break;
							case ClusterResourcePending:
								*returnCode = 24;
								sprintf(clusterState, "Pending");
								break;
							case ClusterResourceOnlinePending:
								*returnCode = 25;
								// Au lancement de SrvManager la ressource est dans l'état "Online Pending".
								// On doit interdire le démarrage seulement si la ressource est dans l'état "Online Pending" sur un autre noeud.
								char pNodeName[100];
								WideCharToMultiByte(CP_ACP, 0, lpszNodeName, -1, pNodeName, 100, 0, 0);
								if (strcmp(pNodeName, infoBuf) == 0)
									sprintf(clusterState, "Offline");
								else
									sprintf(clusterState, "OnlinePending");
								//sprintf(errorMessage, "Serveur : %s , la ressource est en cours sur : %s \n", infoBuf, pNodeName);
								break;
							case ClusterResourceOfflinePending:
								*returnCode = 26;
								sprintf(clusterState, "OfflinePending");
								break;
							default:
								*returnCode = 27;
								sprintf(clusterState, "Unknownstate");
								break;
							}
							//sprintf(errorMessage, "the state of the resource is : %s \n", clusterState);
						}
					}
				}
			}
			*returnCode = 28;
			LocalFree(lpszClusterName);
			*returnCode = 29;
		}
	}
	catch (...)
	{
		*returnCode = 30;
		nError = GetLastError();
		*returnCode = 31;
	}
}