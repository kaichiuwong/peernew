<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class UserAdministration extends MY_PasController {
    
    public function __construct() {
        parent::__construct();
        $this->load->model('User');
    }
    
	public function index()
	{
        if ($this->check_permission(90)) {
            $data['_view'] = 'pages/user/index';
            $data['user_list'] = $this->User->getUserlist();
            $this->load_header();
            $this->load->view('templates/main',$data);
            $this->load_footer();
        }
	}

    public function user_update($updated = false) {
        if ($this->check_permission(90)) {
            $username = $this->input->post('username');
            if (!empty($username)) {
                $email = $this->input->post('email');
                if (!empty($email)) {
                    $new_info = array(
                        'last_name' =>  $this->input->post('lastname'),
                        'first_name' =>  $this->input->post('firstname'),
                        'id' => $this->input->post('st_id'),
                        'email' => $email,
                        'plevel' => $this->input->post('plevel'),
                        'password'  => $this->input->post('password')
                    );
                    $this->User->updateUserInfo($username,$new_info);
                    $updated = true;
                }
                $this->refresh_user_session_info();
                $this->load_header();
                $result = $this->User->getUserInfo($username);
                $data['update_success'] = $updated;
                if (!empty($result)) {
                    $data['username']=$result[0]->username;
                    $data['firstname']=$result[0]->first_name;
                    $data['lastname']=$result[0]->last_name;
                    $data['st_id']=$result[0]->id;
                    $data['email']=$result[0]->email;
                    $data['permission_level']=$result[0]->permission_level;
                    if ($updated) {
                        $data['update_success'] = 'Update Completed.';
                    }
                    $this->load->view('pages/user/user-edit',$data);   
                }      
                $this->load_footer();    
            }
            else {
                redirect('UserAdministration/user_list');
            }
        }
    }
    
    public function create($updated = false) {
        if ($this->check_permission(90)) {
            $username = $this->input->post('username');
            if (!empty($username)) {
                $new_info = array(
                    'username' => $this->input->post('username'),
                    'last_name' =>  $this->input->post('lastname'),
                    'first_name' =>  $this->input->post('firstname'),
                    'id' => $this->input->post('st_id'),
                    'email' => $this->input->post('email'),
                    'plevel' => $this->input->post('plevel'),
                    'password'  => $this->input->post('password')
                );
                $this->User->createUser($new_info);
                $updated = true;
            }
            $data = array();
            if ($updated) {
                $data['update_success'] = 'User Created.';
            }
            $this->load_header();
            $this->load->view('pages/user/user-create',$data);    
            $this->load_footer();
        }
    }
    
    public function bulk_upload() {
        if ($this->check_permission(90)) {
            $this->load_header();
            $result = $this->User->getUserlist();
            if (!empty($result)) {
                $this->load->view('pages/user/user-create-bulk',$result);   
            }      
            $this->load_footer();
        }
    }
    
    public function lock() {
        if ($this->check_permission(90)) {
            $username = $this->input->post('username');
            if (!empty($username)) {
                $this->User->lockuser($username);
            }
        }
        redirect('UserAdministration');
    }
}
