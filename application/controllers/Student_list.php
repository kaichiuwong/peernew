<?php
 
class Student_list extends MY_PasController{
    function __construct()
    {
        parent::__construct();
        $this->load->model('Unit_enrol_model');
        $this->load->model('Assignment_topic_model');
    } 

    function index($asg_id)
    {
        $done = false;

        do 
        {
            if (!$this->check_permission(30) ) break;
            $asg_result = $this->assignment_check($asg_id, false);
            if (!$asg_result['result']) break;
            $decode_asg_id = $asg_result['decode_asg_id'];
            $data['assignment'] = $asg_result['asg_info'];
            $data['asg_header'] = $asg_result['asg_header'];

            $data['asg_id'] = $asg_id;
            $data['_view'] = 'pages/studentlist/index';
            $data['students'] = $this->Unit_enrol_model->get_unit_enrol_by_asgid($asg_id);
            $data['group_list'] = $this->Assignment_topic_model->get_assignment_topic_by_asgid($asg_id);
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
            $done = true;
        } while(0);

        if (!$done) redirect("Assignmentadmin");
    }
    
    function assign_grp() 
    {
        if ($this->check_permission(30)) {
            $ata_id=$this->input->post('ata_id');
            $user_id=$this->input->post('user_id');
            $asg_id=$this->input->post('asg_id');
            $group_id=$this->input->post('group_id');
            if ($asg_id) {
                $this->Unit_enrol_model->assignment_topic_allocation($ata_id, $asg_id, $user_id, $group_id);
                redirect('student_list/index/'.$asg_id);
            }
            else {
                redirect('assignmentadmin');
            }
        }
    }

}
