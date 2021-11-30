const navbarButton = () => {

  const button = document.querySelector('#menu-button');
  const menu = document.querySelector('#menu');

if (button) {  button.addEventListener('click', () => {
      menu.classList.toggle('hidden');
    });
  }
}


export { navbarButton };
