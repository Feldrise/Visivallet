class Permission {
  final List<String> _permissions;
  final List<String> _roles;

  const Permission(this._permissions, this._roles);

  bool can(String permission) {
    return _permissions.contains(permission);
  }

  bool hasRole(String role) {
    return _roles.contains(role);
  }

  // User permissions
  bool canCreateUser() => can('create:user');
  bool canReadUser() => can('read:user');
  bool canReadSelfUser() => can('read:user:self');
  bool canUpdateUser() => can('update:user');
  bool canUpdateSelfUser() => can('update:user:self');
  bool canDeleteUser() => can('delete:user');
  bool canDeleteSelfUser() => can('delete:user:self');

  // Client permissions
  bool canCreateClient() => can('create:client');
  bool canReadClient() => can('read:client');
  bool canReadSelfClient() => can('read:client:self');
  bool canUpdateClient() => can('update:client');
  bool canUpdateSelfClient() => can('update:client:self');
  bool canDeleteClient() => can('delete:client');
  bool canDeleteSelfClient() => can('delete:client:self');

  // Employee permissions
  bool canCreateEmployee() => can('create:employee');
  bool canReadEmployee() => can('read:employee');
  bool canReadSelfEmployee() => can('read:employee:self');
  bool canUpdateEmployee() => can('update:employee');
  bool canUpdateSelfEmployee() => can('update:employee:self');
  bool canDeleteEmployee() => can('delete:employee');
  bool canDeleteSelfEmployee() => can('delete:employee:self');

  // Courses permissions
  bool canCreateCourse() => can('create:course');
  bool canCreateSelfCourse() => can('create:course:self');
  bool canReadCourse() => can('read:course');
  bool canReadSelfCourse() => can('read:course:self');
  bool canUpdateCourse() => can('update:course');
  bool canUpdateSelfCourse() => can('update:course:self');
  bool canDeleteCourse() => can('delete:course');
  bool canDeleteSelfCourse() => can('delete:course:self');

  // Drinks permissions
  bool canCreateDrink() => can('create:drink');
  bool canCreateSelfDrink() => can('create:drink:self');
  bool canReadDrink() => can('read:drink');
  bool canReadSelfDrink() => can('read:drink:self');
  bool canUpdateDrink() => can('update:drink');
  bool canUpdateSelfDrink() => can('update:drink:self');
  bool canDeleteDrink() => can('delete:drink');
  bool canDeleteSelfDrink() => can('delete:drink:self');

  // Roles
  bool isAdmin() => hasRole('admin');
  bool isRcc() => hasRole('rcc');
}
