# Automate local setup with Ansible

To automate the setup of my MacBook and manage my configuration files using Infrastructure as Code (IaC) principles, I used **Ansible**. Ansible is a powerful automation tool that can help you automate the installation of applications, configuration of system settings, and setup of your development environment. Here is a plan to achieve this:

## Step-by-Step Set-up

### 1. **Install Ansible**

First, you need to install Ansible on your current system.

```bash
brew install ansible
```

#### 2. **Create a Git Repository for Your Configuration Files**

Create a new Git repository where you will store your Ansible playbooks and configuration files.

```bash
mkdir macbook-setup && cd macbook-setup
git init
```

#### 3. **Organize Your Repository**

Organize your repository with the following structure:

```plaintext
my-macbook-setup/
├── ansible.cfg
├── inventory
├── playbooks/
│   └── main.yml
└── roles/
    ├── common/
    │   ├── tasks/
    │   │   └── main.yml
    │   ├── files/
    │   └── templates/
    └── applications/
        ├── tasks/
        │   └── main.yml
        ├── files/
        └── templates/
```

#### 4. **Create Ansible Configuration File**

Create an `ansible.cfg` file to configure Ansible.

```ini
[defaults]
inventory = ./inventory
roles_path = ./roles
```

#### 5. **Define Inventory**

Create an `inventory` file to define the target machine (localhost).

```ini
[local]
localhost ansible_connection=local
```

#### 6. **Write Playbooks**

Create a main playbook `playbooks/main.yml` to include various roles.

```yml
- hosts: local
  become: true
  roles:
    - common
    - applications
```

#### 7. **Create Common Role**

Create `roles/common/tasks/main.yml` to handle common setup tasks.

```yml
- name: Update and upgrade Homebrew
  homebrew:
    update_homebrew: yes
    upgrade_all: yes

- name: Install common packages
  homebrew:
    name: "{{ item }}"
    with_items:
      - git
      - zsh
      - htop
```

#### 8. **Create Applications Role**

Create `roles/applications/tasks/main.yml` to install and configure applications.

```yml
- name: Install development tools
  homebrew:
    name: "{{ item }}"
    with_items:
      - visual-studio-code
      - iterm2
      - docker
      - postman

- name: Install Node.js and npm
  homebrew:
    name: node

- name: Clone dotfiles repository
  git:
    repo: "https://github.com/yourusername/dotfiles.git"
    dest: "~/dotfiles"
    version: master

- name: Create symbolic links for dotfiles
  file:
    src: "~/dotfiles/{{ item }}"
    dest: "~/{{ item }}"
    state: link
  with_items:
    - .zshrc
    - .vimrc
    - .gitconfig
```

#### 9. **Push Your Configuration to Git**

Push your configuration files to the Git repository.

```bash
git add .
git commit -m "Initial setup"
git remote add origin <your-repo-url>
git push -u origin master
```

#### 10. **Run Your Ansible Playbook**

Run your Ansible playbook to set up your system.

```bash
ansible-playbook playbooks/main.yml
```

### Conclusion

By following these steps, you can automate the setup of your macbook using Ansible. This approach allows you to quickly provision a new machine with your preferred configurations and installed applications. It also provides a version-controlled setup that you can easily update and maintain.
