<?php
 
class Unit_group_model extends CI_Model
{
    function __construct()
    {
        parent::__construct();
    }

    function get_unit_set($set_id)
    {
        $query_str =  " select us.* " ;
        $query_str .= "   from unit_set us " ;
        $query_str .= "  where us.id = '$set_id' ; " ;
        $query = $this->db->query($query_str);
        return $query->result_array();
    }


    function get_unit_set_group($set_id)
    {
        $query_str =  " select usg.* " ;
        $query_str .= "   from unit_set_group usg " ;
        $query_str .= "  where usg.set_id = '$set_id' ; " ;
        $query = $this->db->query($query_str);
        return $query->result_array();
    }

    function get_unit_set_list($unit_id)
    {
        $query_str =  " select us.* " ;
        $query_str .= "   from unit_set us " ;
        $query_str .= "  where us.unit_id = '$unit_id' ; " ;
        $query = $this->db->query($query_str);
        return $query->result_array();
    }

    function get_unit_set_stat($unit_id)
    {
        $query_str =  " select us.id, us.desc, us.unit_id, count(usg.id) as cnt  " ;
        $query_str .= "   from unit_set us, unit_set_group usg " ;
        $query_str .= "  where us.id = usg.set_id " ;
        $query_str .= "    and us.unit_id = '$unit_id' " ;
        $query_str .= "  group by us.id;  " ;
        $query = $this->db->query($query_str);
        return $query->result_array();
    }

    function get_unit_groups($unit_id)
    {
        $query_str =  " select us.id as unit_set_id, us.desc, us.unit_id, usg.* " ;
        $query_str .= "   from unit_set us, unit_set_group usg " ;
        $query_str .= "  where us.id = usg.set_id" ;
        $query_str .= "    and us.unit_id = '$unit_id' ; " ;
        $query = $this->db->query($query_str);
        return $query->result_array();
    }

    function get_unit_groups_allocation($grp_id)
    {
        $query_str =  " select usg.id as unit_group_id, usg.set_id, usg.group_name, usg.group_desc, usg.max, usga.* " ;
        $query_str .= "   from unit_set_group usg, unit_set_group_allocation usga " ;
        $query_str .= "  where usg.id = usga.group_id" ;
        $query_str .= "    and usg.id = '$grp_id' ; " ;
        $query = $this->db->query($query_str);
        return $query->result_array();
    }

    function create_unit_set($unit_id, $num = 0, $max = 0, $desc='', $prefix = '')
    {
        $params = array (
            'unit_id' => $unit_id,
            'desc' => $desc
        );
        $this->db->insert('unit_set',$params);
        $set_id = $this->db->insert_id();
        if ($set_id) 
        {
            $this->bulk_create_unit_group($set_id, $num, $max, $prefix);
        }
        return $set_id;
    }
    
    function bulk_create_unit_group($set_id, $num = 0, $max = 0, $prefix = '') 
    {
        for ($x = 1; $x <= $num; $x++) {
            $grp_name = 'Group ' . str_pad($x, 3, '0', STR_PAD_LEFT);
            if ($prefix) $grp_name = trim($prefix) . '_' .  str_pad($x, 3, '0', STR_PAD_LEFT); 
            $params = array(
                'set_id' => $set_id,
                'group_name' => $grp_name,
                'max' => $max,
                'group_desc' => $grp_name
            );
            $this->create_unit_group($params);
        }
    }

    function create_unit_group($params)
    {
        $this->db->insert('unit_set_group',$params);
        return $this->db->insert_id();
    }

    function remove_set($set_id) 
    {
        $group_list = $this->get_unit_set_group($set_id);
        foreach($group_list as $grp) {
            $this->remove_groups_allocation($grp['id']);
        }
        $this->db->delete('unit_set_group',array('set_id'=>$set_id));
        $this->db->delete('unit_set',array('id'=>$set_id));
    }

    function remove_groups_allocation($grp_id)
    {
        $this->db->delete('unit_set_group_allocation',array('group_id'=>$grp_id));
    }
}
