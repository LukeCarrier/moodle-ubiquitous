{%
  set web = salt['grains.filter_by']({
    'default': {
      'home_directories': [
        '/home',
      ],
    },
  }, grain='osrelease', merge=salt['pillar.get']('web'))
%}
