import DS from 'ember-data';

export default DS.Model.extend({
  audio_file_name: DS.attr(),
  display_name: DS.attr()
});
