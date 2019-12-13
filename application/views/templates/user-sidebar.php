  <!-- Main Sidebar Container -->
  <aside class="main-sidebar sidebar-dark-primary elevation-4 sidebar-primary">
    <!-- Brand Logo -->
    <a href="<?php echo site_url('Home'); ?>" class="brand-link">
      <span class="brand-text font-weight-light">Peer Assessmenet System</span>
    </a>

    <!-- Sidebar -->
    <div class="sidebar">
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
                <a href="<?php echo site_url('assignment'); ?>" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>Assignment List</p>
                </a>
              </li>
            </ul>
          </li>

          <li class="nav-header">Help</li>
          <li class="nav-item">
            <a href="#" class="nav-link">
              <i class="nav-icon fas fa-file"></i>
              <p>FAQs</p>
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
