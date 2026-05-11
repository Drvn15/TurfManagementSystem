'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('court_sessions', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },

      court_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'courts',
          key: 'id'
        },
        onDelete: 'CASCADE'
      },

      session_type: {
        type: Sequelize.ENUM('MORNING', 'EVENING'),
        allowNull: false
      },

      start_time: {
        type: Sequelize.INTEGER,
        allowNull: false
      },

      end_time: {
        type: Sequelize.INTEGER,
        allowNull: false
      },

      created_at: {
        type: Sequelize.DATE,
        defaultValue: Sequelize.NOW
      },

      updated_at: {
        type: Sequelize.DATE,
        defaultValue: Sequelize.NOW
      }
    });

    // Unique: only one MORNING and one EVENING per court
    await queryInterface.addConstraint('court_sessions', {
      fields: ['court_id', 'session_type'],
      type: 'unique',
      name: 'unique_court_session'
    });

    // Check: start < end
    await queryInterface.sequelize.query(`
      ALTER TABLE court_sessions
      ADD CONSTRAINT check_valid_time
      CHECK (start_time < end_time);
    `);

    // Check: within day
    await queryInterface.sequelize.query(`
      ALTER TABLE court_sessions
      ADD CONSTRAINT check_time_bounds
      CHECK (start_time >= 0 AND end_time <= 1440);
    `);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('court_sessions');
    await queryInterface.sequelize.query(`
      DROP TYPE IF EXISTS "enum_court_sessions_session_type";
    `);
  }
};