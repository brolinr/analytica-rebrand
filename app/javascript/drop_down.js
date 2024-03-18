export default function drop_down() {
  document.addEventListener('click', function(event) {
    let user_menu_button = event.target.closest('#user-menu-button');
    if (user_menu_button) {
      let menu = document.getElementById('dropdown-menu');
      menu.classList.toggle('hidden');
      let expanded = menu.getAttribute('aria-expanded') === 'true' || false;
      menu.setAttribute('aria-expanded', !expanded);
    }
  });
  console.log('sidebar')

  document.addEventListener('click', function(event) {
    let sidebar_button = event.target.closest('#open-sidebar');
    if (sidebar_button) {
      let sidebar = document.getElementById(sidebar_button.dataset.drawerTarget);
      sidebar.classList.toggle('-translate-x-full');
      console.log(sidebar);
    }
  });
}
