
package quickQ_pkg;

    
    // enumerated type for Value Router control signal

    typedef enum logic [2:0] {VR_DEF, VR_ENQ_COMPARE, VR_DEQ_SWAP, VR_LAST, VR_EMPTY, VR_CNT, VR_DEQ_RD} vrMode_t;
    
    typedef enum logic [1:0] {LO_NOP, LO_DEQ, LO_ENQ, LO_ERR} lastOp_t;    

endpackage