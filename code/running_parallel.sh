cluster --machine kaki31 --memoire 6000 --duree 1j --execute 'matlab -nodesktop -r "test1000_BTR_BFGS" ' &
sleep 10s
cluster --machine kaki31 --memoire 6000 --duree 1j --execute 'matlab -nodesktop -r "test1000_BTR_BHHH" ' &
sleep 10s
cluster --machine kaki31 --memoire 6000 --duree 1j --execute 'matlab -nodesktop -r "test1000_BTR_CBBFGS" ' &
sleep 10s
cluster --machine kaki31 --memoire 6000 --duree 1j --execute 'matlab -nodesktop -r "test1000_BTR_CBSR1" ' &
sleep 10s
cluster --machine kaki31 --memoire 6000 --duree 1j --execute 'matlab -nodesktop -r "test1000_BTR_SR1" ' &
sleep 10s
cluster --machine kaki31 --memoire 6000 --duree 1j --execute 'matlab -nodesktop -r "test1000_BTR_SSABFGS" ' &
sleep 10s
cluster --machine kaki31 --memoire 6000 --duree 1j --execute 'matlab -nodesktop -r "test1000_LNS_BFGS" ' &
sleep 10s
cluster --machine kaki31 --memoire 6000 --duree 1j --execute 'matlab -nodesktop -r "test1000_LNS_BHHH" ' &
sleep 10s
cluster --machine kaki31 --memoire 6000 --duree 1j --execute 'matlab -nodesktop -r "test1000_LNS_CBBFGS" ' &
sleep 10s
cluster --machine kaki31 --memoire 6000 --duree 1j --execute 'matlab -nodesktop -r "test1000_LNS_CBSR1" ' &
sleep 10s
cluster --machine kaki31 --memoire 6000 --duree 1j --execute 'matlab -nodesktop -r "test1000_LNS_SR1" ' &
sleep 10s
cluster --machine kaki31 --memoire 6000 --duree 1j --execute 'matlab -nodesktop -r "test1000_LNS_SSABFGS" ' &
sleep 10s
cluster --machine kaki31 --memoire 6000 --duree 1j --execute 'matlab -nodesktop -r "test_BTR_BIGGS" ' &
sleep 10s
cluster --machine kaki31 --memoire 6000 --duree 1j --execute 'matlab -nodesktop -r "test_LNS_BIGGS" ' &
sleep 10s
cluster --machine kaki31 --memoire 6000 --duree 1j --execute 'matlab -nodesktop -r "test1000_TRAIN_BFGS" ' 
