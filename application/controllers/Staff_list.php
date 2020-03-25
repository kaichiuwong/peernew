<?php
 
class Staff_list extends MY_PasController{
    function __construct()
    {
        parent::__construct();
        $this->load->model('Unit_model');
        $this->load->model('Unit_staff_model');
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

            $this->load->model('User');
            $data['_view'] = 'pages/stafflist/index';
            $data['staff'] = $this->Unit_staff_model->get_unit_staff_by_unit($real_unit_id);
            $data['uc_list'] = $this->User->get_user_list_by_permission(50);
            $data['lecturer_list'] = $this->User->get_user_list_by_permission(30);
            $data['tutor_list'] = $this->User->get_user_list_by_permission(20);
            $this->load_header($data);
            $this->load->view('templates/main',$data);
            $this->load_footer($data);
            $done = true;
        } while(0);

        if (!$done) redirect("Unit");
    }

    function add($unit_id)
    {
        if ($unit_id) {
            if ($this->check_permission(50)) {
                $data['unit_id'] = $unit_id ;
                $real_unit_id = decode_id($unit_id);
                if(!empty($real_unit_id) && isset($_POST['username']) ) {
                    if (!$this->Unit_staff_model->get_unit_staff_by_staff($real_unit_id, $_POST['username'])) {
                        $param = array(
                            'unit_id' => $real_unit_id,
                            'username' => $_POST['username']
                        );
                        $this->Unit_staff_model->add_unit_staff($this->get_login_user(), $param);
                    }
                }
                redirect('Staff_list/index/'.$unit_id);
            }
        }
        else {
            redirect('Unit');
        }
    }

    function remove($unit_id)
    {
        if ($unit_id) {
            if ($this->check_permission(50)) {
                $data['unit_id'] = $unit_id ;
                $real_unit_id = decode_id($unit_id);
                if(!empty($unit_id) && isset($_POST['username']) ) {
                    $param = array(
                        'unit_id' => $real_unit_id,
                        'username' => $_POST['username']
                    );
                    $this->Unit_staff_model->delete_unit_staff($param);
                }
                redirect('Staff_list/index/'.$unit_id);
            }
        }
        else {
            redirect('Unit');
        }
    }

}
