<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Member extends MY_PasController {
    
    public function __construct() {
        parent::__construct();
        $this->load->model('User');
    }
    
    public function profile($username) {
        if ($this->check_permission(20, false)) {
            redirect('Member/full_profile/'.$username);
        }
        else if ($this->check_permission(10)) {
            $this->load_header();
            if ($username) {
                $result = $this->User->getUserInfo($username);
                if (!empty($result)) {
                    $data['username']=$result[0]->username;
                    $data['firstname']=$result[0]->first_name;
                    $data['lastname']=$result[0]->last_name;
                    $data['st_id']=$result[0]->id;
                    $data['email']=$result[0]->email;
                    $data['permission_level']=get_permission_level_desc($result[0]->permission_level);

                    $data['_view'] = 'pages/profile';
                    $this->load->view('templates/main',$data);
                }      
            }
            $this->load_footer();
        }
    }

    public function full_profile($username) {
        if ($this->check_permission(90, false)) {
            redirect('Member/edit_profile/'.$username);
        }
        else if ($this->check_permission(20)) {
            $this->load_header();
            if ($username) {
                $result = $this->User->getUserInfo($username);
                if (!empty($result)) {
                    $data['username']=$result[0]->username;
                    $data['firstname']=$result[0]->first_name;
                    $data['lastname']=$result[0]->last_name;
                    $data['st_id']=$result[0]->id;
                    $data['email']=$result[0]->email;
                    $this->load->model('Unit_model');
                    $data['enroll_unit'] = $this->Unit_model->get_list_by_student($username);
                    $data['incharge_unit'] = $this->Unit_model->get_list_by_staff($username);
                    $this->load->model('Assignment_model');

                    $data['_view'] = 'pages/full_profile';
                    $this->load->view('templates/main',$data);
                }      
            }
            $this->load_footer();
        }
    }

    public function edit_profile($username) {
        if ($this->check_permission(90)) {
            if ($username) {
                $this->load_header();
                $result = $this->User->getUserInfo($username);
                if (!empty($result)) {
                    $data['username']=$result[0]->username;
                    $data['firstname']=$result[0]->first_name;
                    $data['lastname']=$result[0]->last_name;
                    $data['st_id']=$result[0]->id;
                    $data['email']=$result[0]->email;
                    $data['plevel']=$result[0]->permission_level;
                    $this->load->model('Unit_model');
                    $data['enroll_unit'] = $this->Unit_model->get_list_by_student($username);
                    $data['incharge_unit'] = $this->Unit_model->get_list_by_staff($username);
                    $this->load->model('Assignment_model');

                    $data['_view'] = 'pages/edit_profile';
                    $this->load->view('templates/main',$data);
                }      
                $this->load_footer();
            }
            else 
            {
                redirect('Useradministration');
            }
        }
    }

    public function create() {
        if ($this->check_permission(90)) {
            if (isset($_POST['username'])) {
                $data['param'] = array(
                    'username' => $this->input->post('username'),
                    'first_name' => $this->input->post('firstname'),
                    'last_name' => $this->input->post('lastname'),
                    'id' => $this->input->post('st_id'),
                    'email' => $this->input->post('email'),
                    'plevel'  => $this->input->post('plevel'),
                    'password'  => $this->input->post('password')
                );
                $result = $this->User->getUserInfo($this->input->post('username'));
                $emailresult = $this->User->getUserInfoByEmail($this->input->post('email'));
                if (!isset($result[0]->username) && !isset($emailresult[0]->email)) {
                    $data['status'] = $this->User->createUser($data['param'] );
                    redirect('Member/edit_profile/'.$this->input->post('username'));
                }
                else {
                    if ($result) {
                        $data['error'] = "User already exist.";
                    }
                    if ($emailresult) {
                        $data['emailerror'] = "Email already exist.";
                    }
                }
            }
            $this->load_header();
            $data['_view'] = 'pages/create_profile';
            $this->load->view('templates/main',$data);
            $this->load_footer();
        }
    }

    public function update($username) {
        if ($this->check_permission(90)) {
            if (isset($_POST['username'])) {
                $param = array(
                    'first_name' => $this->input->post('firstname'),
                    'last_name' => $this->input->post('lastname'),
                    'id' => $this->input->post('st_id'),
                    'email' => $this->input->post('email'),
                    'plevel'  => $this->input->post('plevel')
                );
                $result = $this->User->updateUserInfo($this->input->post('username'), $param);
            }
            redirect('Member/edit_profile/'.$username);
        }
    }
}
