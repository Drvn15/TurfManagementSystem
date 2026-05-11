'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    // Check if column exists before adding
    const table = await queryInterface.describeTable('Turf');
    
    if (!table.owner_id) {
      await queryInterface.addColumn('Turf', 'owner_id', {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'User',
          key: 'id',
        },
        onDelete: 'CASCADE',
      });
    }
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn('Turf', 'owner_id');
  },
};
