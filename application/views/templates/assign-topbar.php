<!-- Topbar -->
<nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">
  <ul class="navbar-nav" >
      <li class="nav-item">
          <a class="nav-link" href="<?php echo site_url('Assignmentadmin/assignment_list/'); ?>">
            <span class="mr-2 d-none d-lg-inline text-gray-<?php echo (strpos($this->router->fetch_method(), 'assignment_list') !== false)? 500: 900; ?>">Assignment List</span>
          </a>
      </li>
      <li class="nav-item">
          <a class="nav-link" href="<?php echo site_url('Assignmentadmin/edit/'.$asg_id ); ?>">
            <span class="mr-2 d-none d-lg-inline text-gray-<?php echo (strpos($this->router->fetch_method(), 'edit') !== false)? 500: 900; ?>">Description</span>
          </a>
      </li>
      <li class="nav-item">
          <a class="nav-link" href="<?php echo site_url('Assignmentadmin/deadline/'.$asg_id ); ?>">
            <span class="mr-2 d-none d-lg-inline text-gray-<?php echo (strpos($this->router->fetch_method(), 'deadline') !== false)? 500: 900; ?>">Deadline</span>
          </a>
      </li>
      <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" id="topicDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <span class="mr-2 d-none d-lg-inline text-gray-<?php echo (strpos($this->router->fetch_method(), 'topic') !== false)? 500: 900; ?>">Topics</span>
          </a>
          <!-- Dropdown - User Information -->
          <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in" aria-labelledby="topicDropdown">
            <a class="dropdown-item" href="assign-topic.php">
              Topic List
            </a>
            <a class="dropdown-item" href="assign-topic-allocation.php">
              Topic Allocation
            </a>
          </div>
      </li>
      <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" href="#" id="assignmarkingDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          <span class="mr-2 d-none d-lg-inline text-gray-<?php echo (strpos($this->router->fetch_method(), 'criteria') !== false)? 500: 900; ?>">Marking Criteria</span>
        </a>
        <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in" aria-labelledby="assignmarkingDropdown">
          <a class="dropdown-item" href="<?php echo site_url('Assignmentadmin/marking_criteria_list/'.$asg_id ); ?>">
            Assignment Marking
          </a>
          <a class="dropdown-item" href="<?php echo site_url('Assignmentadmin/feedback_criteria_list/'.$asg_id ); ?>">
            Feedback Marking
          </a>
        </div>
      </li>
      <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" href="#" id="studentDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          <span class="mr-2 d-none d-lg-inline text-gray-<?php echo (strpos($this->router->fetch_method(), 'student-manage') !== false)? 500: 900; ?>">Students</span>
        </a>
        <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in" aria-labelledby="studentDropdown">
          <a class="dropdown-item" href="student-manage-list.php">
            Student List
          </a>
          <a class="dropdown-item" href="student-manage-peer.php">
            Peer Allocation
          </a>
        </div>
      </li>
      <li class="nav-item dropdown">
          <a class="nav-link" href="assign-progress.php">
            <span class="mr-2 d-none d-lg-inline text-gray-<?php echo (strpos($this->router->fetch_method(), 'assign-progress') !== false)? 500: 900; ?>">Assignment Progress</span>
          </a>
      </li>
  </ul>
  <!-- Topbar Navbar -->
  <ul class="navbar-nav ml-auto">

    <div class="topbar-divider d-none d-sm-block"></div>

    <!-- Nav Item - User Information -->
    <li class="nav-item dropdown no-arrow">
      <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        <span class="mr-2 d-none d-lg-inline text-gray-600 small"><?php echo $user; ?></span>
      </a>
      <!-- Dropdown - User Information -->
      <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in" aria-labelledby="userDropdown">
        <a class="dropdown-item" href="<?php echo site_url('Setting/profile'); ?>">
          <i class="fas fa-user fa-sm fa-fw mr-2 text-gray-400"></i>
          Profile
        </a>
        <div class="dropdown-divider"></div>
        <a class="dropdown-item" href="<?php echo site_url('Usercontrol/logout'); ?>" data-toggle="modal" data-target="#logoutModal">
          <i class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i>
          Logout
        </a>
      </div>
    </li>

  </ul>

</nav>
<!-- End of Topbar -->
