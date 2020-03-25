<?php
 
class Semester_model extends CI_Model
{
    function __construct()
    {
        parent::__construct();
    }

    function get_all_sem()
    {
        $this->db->order_by('sem', 'asc');
        return $this->db->get('semester')->result_array();
    }
}
