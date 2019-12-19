<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Member extends MY_PasController {
    
    public function __construct() {
        parent::__construct();
        $this->load->model('User');
    }
    
    public function profile($username) {
        if ($this->check_permission(10)) {
            $this->load_header();
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
            $this->load_footer();
        }
    }

}
