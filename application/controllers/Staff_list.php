<?php
 
class Staff_list extends MY_PasController{
    function __construct()
    {
        parent::__construct();
        $this->load->model('Unit_staff_model');
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

            $this->load->model('User');
            $data['asg_id'] = $asg_id;
            $data['_view'] = 'pages/stafflist/index';
            $data['staff'] = $this->Unit_staff_model->get_unit_staff_by_asg($asg_id);
            $data['uc_list'] = $this->User->get_user_list_by_permission(50);
            $data['lecturer_list'] = $this->User->get_user_list_by_permission(30);
            $data['tutor_list'] = $this->User->get_user_list_by_permission(20);
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
            $done = true;
        } while(0);

        if (!$done) redirect("Assignmentadmin");
    }

    function add($asg_id)
    {
        if ($asg_id) {
            if ($this->check_permission(30)) {
                $this->load->model('Assignment_model');
                $assignment = $this->Assignment_model->get_assignment($asg_id);
                if(isset($assignment['asg_id']) && isset($_POST['username']) ) {
                    $param = array(
                        'unit_id' => $assignment['unit_id'],
                        'username' => $_POST['username']
                    );
                    $this->Unit_staff_model->add_unit_staff($this->get_login_user(), $param);
                }
                redirect('Staff_list/index/'.$asg_id);
            }
        }
        else {
            redirect('Assignmentadmin');
        }
    }

    function remove($asg_id)
    {
        if ($asg_id) {
            if ($this->check_permission(30)) {
                $this->load->model('Assignment_model');
                $assignment = $this->Assignment_model->get_assignment($asg_id);
                if(isset($assignment['asg_id']) && isset($_POST['username']) ) {
                    $param = array(
                        'unit_id' => $assignment['unit_id'],
                        'username' => $_POST['username']
                    );
                    $this->Unit_staff_model->delete_unit_staff($param);
                }
                redirect('Staff_list/index/'.$asg_id);
            }
        }
        else {
            redirect('Assignmentadmin');
        }
    }

}
