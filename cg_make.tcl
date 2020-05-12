proc cgrep {id} {
    # Process for re-defining bonds for 
    # CGnet molecule visualiization

    # Parameters
    # ----------
    # id : int
    #    molecule id

    # Returns
    # -------
    # None

	puts "creating CG representation for molecule $id..."
	mol modstyle 0 $id VDW 4 60
    mol modcolor 0 $id Index
    mol addrep $id
    mol modstyle 1 $id Bonds 2.5 60
    mol modcolor 1 $id Index

    # Define the CA-CA pseudobonds
    set CA [atomselect $id "name CA"]
    set CA_idx [$CA get index]
    for {set i 0} {$i < [llength $CA_idx] - 1} {incr i} {
        set ca_idx_1 [lindex $CA_idx $i]
        set ca_idx_2 [lindex $CA_idx $i+1]
        topo addbond $ca_idx_1 $ca_idx_2
    }

    # Define the CA-CB pseudobonds
    # Resid is 1-indexed
    for {set i 1} {$i <= [llength $CA_idx]} {incr i} {
        set res_name [lindex [[atomselect $id "resid $i"] get resname] 0]
        # Glycine Filter
        if {[string compare "$res_name" "GLY"] != 0} { 
        	set res [atomselect $id "resid $i and (name CA or name CB)"]
        	set indices [$res get index] 
        	set ca_idx [lindex $indices 0]
        	set cb_idx [lindex $indices 1]
        	topo addbond $ca_idx $cb_idx 
        }
    }
}

