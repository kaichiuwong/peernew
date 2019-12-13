<?php
/* 
 * Generated by CRUDigniter v3.2 
 * www.crudigniter.com
 */
 
class Unit_staff_model extends CI_Model
{
    function __construct()
    {
        parent::__construct();
    }
    
    /*
     * Get unit_staff by id
     */
    function get_unit_staff($id)
    {
        return $this->db->get_where('unit_staff',array('id'=>$id))->row_array();
    }
    
    /*
     * Get all unit_staffs count
     */
    function get_all_unit_staffs_count()
    {
        $this->db->from('unit_staff');
        return $this->db->count_all_results();
    }
        
    /*
     * Get all unit_staffs
     */
    function get_all_unit_staffs($params = array())
    {
        $this->db->order_by('id', 'desc');
        if(isset($params) && !empty($params))
        {
            $this->db->limit($params['limit'], $params['offset']);
        }
        return $this->db->get('unit_staff')->result_array();
    }
        
    /*
     * function to add new unit_staff
     */
    function add_unit_staff($params)
    {
        $this->db->insert('unit_staff',$params);
        return $this->db->insert_id();
    }
    
    /*
     * function to update unit_staff
     */
    function update_unit_staff($id,$params)
    {
        $this->db->where('id',$id);
        return $this->db->update('unit_staff',$params);
    }
    
    /*
     * function to delete unit_staff
     */
    function delete_unit_staff($id)
    {
        return $this->db->delete('unit_staff',array('id'=>$id));
    }
}
