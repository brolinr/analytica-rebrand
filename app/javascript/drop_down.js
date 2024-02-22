document.getElementById('user-menu-button').addEventListener('click', function () {
  let menu = document.getElementById('dropdown-menu');
  menu.classList.toggle('hidden');
  let expanded = menu.getAttribute('aria-expanded') === 'true' || false;
  menu.setAttribute('aria-expanded', !expanded);
});

let sidebar_button = document.getElementById('open-sidebar')
sidebar_button.addEventListener('click', function () {
  let sidebar = document.getElementById(sidebar_button.dataset.drawerTarget)
  sidebar.classList.toggle('-translate-x-full')
  console.log(sidebar)
})