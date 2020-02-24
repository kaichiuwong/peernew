<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Setting extends MY_PasController {
    
    public function __construct() {
        parent::__construct();
        $this->load->model('User');
    }
    
	public function index()
	{
        redirect('Setting/profile');
	}
    
    public function profile($updated = false) {
        if ($this->check_permission(10)) {
            $this->load_header();
            $result = $this->User->getUserInfo($this->get_login_user());
            if (!empty($result)) {
                $data['username']=$result[0]->username;
                $data['firstname']=$result[0]->first_name;
                $data['lastname']=$result[0]->last_name;
                $data['st_id']=$result[0]->id;
                $data['email']=$result[0]->email;
                $data['permission_level']=get_permission_level_desc($result[0]->permission_level);
                if ($updated) {
                    $data['update_success'] = 'Update Completed.';
                }
                $data['_view'] = 'pages/user/profile';
                $this->load->view('templates/main',$data);
            }      
            $this->load_footer();
        }
    }
    
    public function update_profile() {
        $username = $this->input->post('username');
        $updated = false;
        if ($username == $this->get_login_user()) {
            $new_info = array(
                'last_name' =>  $this->input->post('lastname'),
                'first_name' =>  $this->input->post('firstname'),
                'password'  => $this->input->post('password')
            );
            $this->User->updateUserInfo($username,$new_info);
            $updated = true;
            $this->refresh_user_session_info();
        }
        redirect('Setting/profile/updated');
    }

    public function refresh_enrol() {
        $this->load->model('User_enrol_model');
        $this->User_enrol_model->refresh_enrol_from_db();
    }
}
