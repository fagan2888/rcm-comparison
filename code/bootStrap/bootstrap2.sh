cluster --machine kaki42 --memoire 6000 --duree 1j --execute 'cd .. && matlab -nodesktop -r "loadWorkspace; bootstrapping 801 850" ' &
sleep 10s
cluster --machine kaki42 --memoire 6000 --duree 1j --execute 'cd .. && matlab -nodesktop -r "loadWorkspace; bootstrapping 851 900" ' &
sleep 10s
cluster --machine kaki42 --memoire 6000 --duree 1j --execute 'cd .. && matlab -nodesktop -r "loadWorkspace; bootstrapping 901 950" ' &
sleep 10s
cluster --machine kaki42 --memoire 6000 --duree 1j --execute 'cd .. && matlab -nodesktop -r "loadWorkspace; bootstrapping 951 1000" ' &
sleep 10s


