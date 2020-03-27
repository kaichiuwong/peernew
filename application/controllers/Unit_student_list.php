<?php
 
class Unit_student_list extends MY_PasController{
    function __construct()
    {
        parent::__construct();
        $this->load->model('Unit_model');
        $this->load->model('Unit_enrol_model');
        $this->load->model('Assignment_topic_model');
    } 

    function index($unit_id)
    {
        $done = false;

        do 
        {
            if (!$this->check_permission(50) ) break;
            $data['unit_id'] = $unit_id ;
            $real_unit_id = decode_id($unit_id);
            if (empty($real_unit_id)) break;
            $data['unit_info']=$this->Unit_model->get_unit_info($real_unit_id)[0];
            $data['unit_header']=$data['unit_info']->unit_code . ' - '. $data['unit_info']->unit_description;

            $data['_view'] = 'pages/unit_student/index';
            $data['students'] = $this->Unit_enrol_model->get_unit_enrol_by_unitid($real_unit_id);
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
            $done = true;
        } while(0);

        if (!$done) redirect("Unit");
    }
    
    function assign_grp() 
    {
        if ($this->check_permission(50)) {
            $ata_id=$this->input->post('ata_id');
            $user_id=$this->input->post('user_id');
            $asg_id=$this->input->post('asg_id');
            $group_id=$this->input->post('group_id');
            if ($asg_id) {
                $this->Unit_enrol_model->assignment_topic_allocation($ata_id, $asg_id, $user_id, $group_id);
                redirect('Unit_student_list/index/'.$asg_id);
            }
            else {
                redirect('Unit');
            }
        }
    }

}
