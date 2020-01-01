  <!-- Main Sidebar Container -->
  <aside class="main-sidebar sidebar-dark-primary elevation-4">
    <!-- Brand Logo -->
    <a href="<?php echo site_url('Home'); ?>" class="brand-link text-center ">
      <span class="brand-text font-weight-bold"><?php echo SYSTEM_FRIENDLY_NAME;?></span>
    </a>

    <!-- Sidebar -->
    <div class="sidebar sidebar-dark">
      <!-- Sidebar Menu -->
      <nav class="mt-2">
        <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
          <li class="nav-item">
            <a href="<?php echo site_url('Home'); ?>" class="nav-link">
              <i class="nav-icon fas fa-home"></i>
              <p>Home</p>
            </a>
          </li>
          <li class="nav-item has-treeview">
            <a href="#" class="nav-link">
              <i class="nav-icon fas fa-table"></i>
              <p>Assignment <i class="fas fa-angle-left right"></i></p>
            </a>
            <ul class="nav nav-treeview">
              <li class="nav-item">
                <a href="<?php echo site_url('Assignmentadmin'); ?>" class="nav-link">
                  <i class="fas fa-table nav-icon"></i>
                  <p>Assignment List</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="<?php echo site_url('Assignmentadmin/add'); ?>" class="nav-link">
                  <i class="fas fa-table nav-icon"></i>
                  <p>Create Assignment</p>
                </a>
              </li>
            </ul>
          </li>
          <li class="nav-item">
            <a href="<?php echo site_url('Marking'); ?>" class="nav-link">
              <i class="nav-icon fas fa-edit"></i>
              <p>Marking</p>
            </a>
          </li>
          <li class="nav-item">
            <a href="#" class="nav-link">
              <i class="nav-icon fas fa-file"></i>
              <p>FAQs</p>
            </a>
          </li>
          <li class="nav-item">
            <a href="<?php echo site_url('Usercontrol/logout'); ?>" class="nav-link">
              <i class="nav-icon fas fa-sign-out-alt"></i>
              <p>Logout</p>
            </a>
          </li>
        </ul>
      </nav>
      <!-- /.sidebar-menu -->
      
    </div>
    <!-- /.sidebar -->
  </aside>