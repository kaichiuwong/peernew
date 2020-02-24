  <!-- Main Sidebar Container -->
  <aside class="main-sidebar sidebar-dark-primary elevation-4">
    <!-- Brand Logo -->
    <a href="<?php echo site_url('Home'); ?>" class="brand-link text-center">
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
          <li class="nav-header">Assignment</li>
          <li class="nav-item">
            <a href="<?php echo site_url('Assignment'); ?>" class="nav-link">
              <i class="nav-icon fas fa-file-upload"></i>
              <p>Submission</p>
            </a>
          </li>
          <li class="nav-header"></li>
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
